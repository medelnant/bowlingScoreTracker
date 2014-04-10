//
//  BST_SessionsTableViewController.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/9/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_SessionsTableViewController.h"
#import "BST_VenueTableViewController.h"

@interface BST_SessionsTableViewController ()

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
            NSLog(@"Success! here is the object returned.");
            NSLog(@"%lu", (unsigned long)objects.count);
            
            //Store query on clientSide within NSMutableArray
            _clientSessionArray = [NSMutableArray arrayWithArray:objects];
            
            //Reload tableView after query object is returned
            [[self tableView] reloadData];
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
    return _clientSessionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sessionCell"];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell" forIndexPath:indexPath];
    
    NSString * sessionTitle = [[_clientSessionArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    NSString * updatedAt = [NSString stringWithFormat:@"Created At: %@", [[_clientSessionArray objectAtIndex:indexPath.row] valueForKey:@"updatedAt"]];
    
    cell.textLabel.text = sessionTitle;
    cell.detailTextLabel.text = updatedAt;
    
    return cell;
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
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"venues"]) {
        
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
                                                       delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Callback Will!");
    NSString * sessionTitle = [[alertView textFieldAtIndex: 0] text];
    
    //Create new PFObject
    _createdSession = [PFObject objectWithClassName:@"Session"];
    
    //Set title attribute for object
    [_createdSession setObject:sessionTitle forKey:@"title"];
    
    // Create relationship
    [_createdSession setObject:[PFUser currentUser] forKey:@"bowler"];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"Callback Did!");
    [self performSegueWithIdentifier:@"venues" sender:nil];
}

@end
