//
//  BST_SessionsTableViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/9/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_SessionsTableViewController.h"
#import "BST_SessionDetailViewController.h"
#import "BST_VenueTableViewController.h"
#import "BST_SessionCardTableViewCell.h"

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

- (void)viewWillAppear:(BOOL)animated {
    //Show NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Styling
    [self.view setBackgroundColor: [UIColor colorWithRed:0.84 green:0.83 blue:0.85 alpha:1]];
    
    //Style Navigation Bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.14 green:0.14 blue:0.21 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]}];
    
    //Add Border to NavigationBar
    [[self.navigationController.navigationBar viewWithTag:55] removeFromSuperview];
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height-4,self.navigationController.navigationBar.frame.size.width, 2)];
    navBorder.tag = 66;
    [navBorder setBackgroundColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]];
    [navBorder setOpaque:YES];
    [self.navigationController.navigationBar addSubview:navBorder];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1];
    self.navigationController.navigationBar.translucent = YES;
    
    
    //Add gesture for swiping within navBar to trigger drawer slide open/close
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    //Set View Title
    self.navigationItem.title = @"Sessions";
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationMenuIcon.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector( revealToggle: )];
    
    //Add barButton right to trigger drawer slide open/close
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSession)];
    
    //Create session query for tableView
    _sessionQuery = [PFQuery queryWithClassName:@"Session"];

    
    //Define order
    [_sessionQuery orderByDescending:@"createdAt"];
    
    //Bind relationship to currentUser for query
    [_sessionQuery whereKey:@"bowler" equalTo:[PFUser currentUser]];

    //In a background thread fetch all data syncronously
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Use findObject instead of findObjectInBackground to guarantee all data has been loaded by the end of the method
        NSArray * sessions = [_sessionQuery findObjects];
        
        //For all sessions query games
        for (NSInteger i =0; i < sessions.count; i++) {
            sessions[i][@"games"] = [[[sessions[i] relationForKey:@"games"] query] findObjects];
        }
        
        //Utilize main que because any UI Operations MUST be done on the main que
        dispatch_async(dispatch_get_main_queue(), ^{
            _clientSideSessionArray = [NSMutableArray arrayWithArray:sessions];
            
            [[self tableView] reloadData];
        });
    });
    
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


- (BST_SessionCardTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Create array instance of just the games for this session
    NSArray * sessionGamesArray = [_clientSideSessionArray[indexPath.row] valueForKey:@"games"];
    
    
    
    //Pointer for holding total series
    int sessionTotalSeries = 0;
    
    //Total up series for session
    for (NSInteger i = 0; i < sessionGamesArray.count; i++) {
        sessionTotalSeries += [[sessionGamesArray[i] valueForKey:@"totalScore"] intValue];
    }
    
    NSLog(@"Total Series is = %d", sessionTotalSeries);
    
    //Do the math to determine average
    int sessionAverage = sessionTotalSeries/sessionGamesArray.count;
    
    NSString * sessionLocation = [NSString stringWithFormat:@"%@, %@", [_clientSideSessionArray[indexPath.row] valueForKey:@"venueName"], [_clientSideSessionArray[indexPath.row] valueForKey:@"city"]];
    
    //Session Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *sessionDate = [dateFormatter stringFromDate:[_clientSideSessionArray[indexPath.row] valueForKey:@"createdAt"]];
    
    BST_SessionCardTableViewCell *cell = (BST_SessionCardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
    
    //Store title and creationDate within NSString pointer references
    NSString * sessionTitle = [[_clientSideSessionArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    //NSString * sessionRecap = [NSString stringWithFormat:@"%ld games | %d series | %d average", sessionGamesArray.count, sessionTotalSeries, sessionAverage];
    
    //Write values to appropriate labels within cell
    
    cell.sessionTitle.text = sessionTitle;
    cell.sessionDate.text = sessionDate;
    cell.sessionVenue.text = sessionLocation;
    cell.sessionNumberOfGames.text = [NSString stringWithFormat:@"%lu", (unsigned long)sessionGamesArray.count];
    cell.sessionSeries.text = [NSString stringWithFormat:@"%d", sessionTotalSeries];
    cell.sessionAverage.text = [NSString stringWithFormat:@"%d", sessionAverage];
    
    //cell.textLabel.text = sessionTitle;
    //cell.detailTextLabel.text = sessionRecap;
    //cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    //cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //NSLog(@"%@", [NSString stringWithFormat:@"Session ObjectId : %@", [[_clientSideSessionArray objectAtIndex:indexPath.row] valueForKey:@"objectId"]]);
    
    //Set the session that will be passed to detail view
    _detailedSession = [_clientSideSessionArray objectAtIndex:indexPath.row];
    
    //Proceeed to game scoring view
    [self performSegueWithIdentifier:@"sessionDetailView" sender:nil];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        NSInteger sessionIndex = indexPath.row;
        
        //Call to deleteSession method
        [self deleteSession:sessionIndex];
        
        //Remove row from tableview
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
    
    if([segue.identifier isEqualToString:@"sessionDetailView"]) {
        
        BST_SessionDetailViewController *destinationViewController = segue.destinationViewController;
        
        if(destinationViewController != nil) {
            
            //Pass Object to step 2: select bowling center
            destinationViewController.detailedSession = _detailedSession;
            
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
- (void)addGamesQueryToSessions {
    
    if(_clientSideGameArray.count > 0 && _clientSideGameArray > 0) {
        //Take gamesArray and add each game to a games container within session array.... phew!
        for (NSInteger i = 0; i < _clientSideGameArray.count; i++) {
            
            NSString * gameSessionID = [[_clientSideGameArray[i] valueForKey:@"session"] valueForKey:@"objectId"];
            NSMutableArray * gameArray = [[NSMutableArray alloc]init];
            gameArray = [_clientSideGameArray[i] valueForKey:@"gameArray"];
            
            for (NSInteger j = 0; j < _clientSideSessionArray.count; j++) {
                NSString * sessionID = [_clientSideSessionArray[j] valueForKey:@"objectId"];
                
                NSMutableArray * gamesContainer = [[NSMutableArray alloc]init];
                [gamesContainer addObjectsFromArray:gameArray];
                
                if([gameSessionID isEqualToString:sessionID]) {
                    [_clientSideSessionArray[j] addObject:gamesContainer forKey:@"games"];
                }
            }
        }
        
        NSLog(@"New Session Object %@",[_clientSideSessionArray[0] valueForKey:@"games"]);
        
        //Check session count to alert user with frienly uiAlertView to create session
        [self checkSessionCount];
        
        [[self tableView] reloadData];
        
    }
}
 */

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
