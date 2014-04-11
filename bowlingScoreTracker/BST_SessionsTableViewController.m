//
//  BST_SessionsTableViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 2 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/9/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_SessionsTableViewController.h"
#import "BST_VenueTableViewController.h"

@interface BST_SessionsTableViewController ()

#define TAG_EMPTYLIST 1
#define TAG_CREATESESSION 2

@end

@implementation BST_SessionsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add gesture for swiping within navBar to trigger drawer slide open/close
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    //Set View Title
    self.navigationItem.title = @"Sessions";
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self.revealViewController action:@selector( revealToggle: )];
    
    //Add barButton right to trigger drawer slide open/close
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSession)];
    
    //Create Query for tableView
    _sessionQuery = [PFQuery queryWithClassName:@"Session"];
    
    //Define order
    [_sessionQuery orderByDescending:@"createdAt"];
    
    //Define Cache Policy
    _sessionQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    //Bind relationship to currentUser for query
    [_sessionQuery whereKey:@"bowler" equalTo:[PFUser currentUser]];
    
    //Go Fetch
    [_sessionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            //NSLog(@"Success! here is the object returned.");
            //NSLog(@"%lu", (unsigned long)objects.count);
            
            //Store query on clientSide within NSMutableArray
            _clientSideSessionArray = [NSMutableArray arrayWithArray:objects];
            
            //Reload tableView after query object is returned
            [[self tableView] reloadData];
            
            //Check session count to alert user with frienly uiAlertView to create session
            [self checkSessionCount];
        } else {
            NSLog(@"Query error. Not good!");
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _clientSideSessionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sessionCell"];
    
    //Store title and creationDate within NSString pointer references
    NSString * sessionTitle = [[_clientSideSessionArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    NSString * updatedAt = [NSString stringWithFormat:@"Created At: %@", [[_clientSideSessionArray objectAtIndex:indexPath.row] valueForKey:@"updatedAt"]];
    
    //Write values to appropriate labels within cell
    cell.textLabel.text = sessionTitle;
    cell.detailTextLabel.text = updatedAt;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //NSLog(@"%@", [NSString stringWithFormat:@"Session ObjectId : %@", [[_clientSideSessionArray objectAtIndex:indexPath.row] valueForKey:@"objectId"]]);
    
    //Store objectId in pointer reference from clientSideSessionArray
    NSString * sessionObjectId = [[_clientSideSessionArray objectAtIndex:indexPath.row] valueForKey:@"objectId"];
    
    //Define Query for retrieving specific PFObject
    PFQuery *query = [PFQuery queryWithClassName:@"Session"];
    [query whereKey:@"objectId" equalTo:sessionObjectId];
    
    //Perform Query
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error) {
            _createdSession = object;
            [self performSegueWithIdentifier:@"gameScoring" sender:nil];
        } else {
            NSLog(@"Query Error for existing session in tableViewList");
        }
        
    }];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSInteger sessionIndex = indexPath.row;
        [self deleteSession:sessionIndex];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"venues"] || [segue.identifier isEqualToString:@"gameScoring"]) {
        
        BST_VenueTableViewController *destinationViewController = segue.destinationViewController;
        
        if(destinationViewController != nil) {

            //Pass Object to step 2: select bowling center
            destinationViewController.currentSession = _createdSession;
            
        }
        
    }

}

- (void)addSession {
    NSLog(@"Add Session Clicked!");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Create New Session"
                                                        message:nil
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Next", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = TAG_CREATESESSION;
    [alertView show];

}

- (void)deleteSession:(NSInteger)sessionIndex {
    //NSLog(@"%@", [NSString stringWithFormat:@"Session Index to be deleted: %ld", (long)sessionIndex]);
    
    //Capture objectId and title within NSString pointer references
    NSString *sessionId = [[_clientSideSessionArray objectAtIndex:sessionIndex] valueForKey:@"objectId"];
    NSString *sessionTitle = [[_clientSideSessionArray objectAtIndex:sessionIndex] valueForKey:@"title"];
    
    //Remove session from clientSideSessionArray
    [_clientSideSessionArray removeObjectAtIndex:sessionIndex];
    
    //Define query to delete selected session
    PFQuery * deleteSessionQuery = [PFQuery queryWithClassName:@"Session"];
    [deleteSessionQuery getObjectInBackgroundWithId:sessionId block:^(PFObject *object, NSError *error) {
        if(!error) {
            
            //Define new PFObject from returned obj.
            PFObject * toBeDeletedSession = object;
            [toBeDeletedSession deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Session Deleted"
                                                                        message:[NSString stringWithFormat:@"%@ has been deleted.", sessionTitle]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];

        }
    }];
}

- (void)checkSessionCount {
    if(_clientSideSessionArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Create Session"
                                                            message:@"Looks like you have no sessions created. Would you like to create one now?"
                                                           delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag = TAG_EMPTYLIST;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    //NSLog(@"Callback Will!");
    
    NSLog(@"%@", [NSString stringWithFormat:@"Alert Button Index: %ld", (long)buttonIndex]);
    
    if(buttonIndex != 0) {
        if (alertView.tag == TAG_CREATESESSION) {
        
            //Retrive text from textfield and assign to pointer
            NSString * sessionTitle = [[alertView textFieldAtIndex: 0] text];
            
            //Create new PFObject
            _createdSession = [PFObject objectWithClassName:@"Session"];
            
            //Set title attribute for object
            [_createdSession setObject:sessionTitle forKey:@"title"];
            
            // Create relationship
            [_createdSession setObject:[PFUser currentUser] forKey:@"bowler"];
            
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //NSLog(@"Callback Did!");
    
    if (alertView.tag == TAG_CREATESESSION) {
        if(buttonIndex != 0) {
            [self performSegueWithIdentifier:@"venues" sender:nil];
        }
    } else if(alertView.tag == TAG_EMPTYLIST) {
        if(buttonIndex != 0) {
            [self addSession];
        }

    }

}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
