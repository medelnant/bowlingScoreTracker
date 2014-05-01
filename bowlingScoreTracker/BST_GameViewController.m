//
//  BST_GameViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/10/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_GameViewController.h"

@interface BST_GameViewController ()

@end

@implementation BST_GameViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set View Title
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [_currentSession valueForKey:@"title"]];
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self.revealViewController action:@selector( revealToggle: )];
    
    //Add barButton right to trigger drawer slide open/close
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGame)];
    
    //Call query method
    [self findGamesAssociatedWithSession];
    
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
    return _clientSideGamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"gameCell"];
    
    //Store title and creationDate within NSString pointer references
    NSString * sessionTitle = [[_clientSideGamesArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    NSString * updatedAt = [NSString stringWithFormat:@"Created At: %@", [[_clientSideGamesArray objectAtIndex:indexPath.row] valueForKey:@"updatedAt"]];
    
    //Write values to appropriate labels within cell
    cell.textLabel.text = sessionTitle;
    cell.detailTextLabel.text = updatedAt;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSInteger gameIndex = indexPath.row;
        [self deleteGame:gameIndex];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Custom Methods

- (void)addGame {
    
    NSLog(@"Add Game Clicked!");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Create New Game"
                                                        message:nil
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Next", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];

}

- (void)deleteGame:(NSInteger)gameIndex {
    //NSLog(@"%@", [NSString stringWithFormat:@"Game Index to be deleted: %ld", (long)gameIndex]);
    
    //Capture objectId and title within NSString pointer references
    NSString *gameId = [[_clientSideGamesArray objectAtIndex:gameIndex] valueForKey:@"objectId"];
    NSString *gameTitle = [[_clientSideGamesArray objectAtIndex:gameIndex] valueForKey:@"title"];
    
    //Remove session from clientSideGamesArray
    [_clientSideGamesArray removeObjectAtIndex:gameIndex];
    
    //Define query to delete selected game
    PFQuery * deleteGameQuery = [PFQuery queryWithClassName:@"Game"];
    [deleteGameQuery getObjectInBackgroundWithId:gameId block:^(PFObject *object, NSError *error) {
        if(!error) {
            
            //Define new PFObject from returned obj.
            PFObject * toBeDeletedSession = object;
            [toBeDeletedSession deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Deleted"
                                                                        message:[NSString stringWithFormat:@"%@ has been deleted.", gameTitle]
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

- (void)findGamesAssociatedWithSession {
    
    //Define query class
    _currentSessionGameQuery = [PFQuery queryWithClassName:@"Game"];
    
    //Define query relationship
    [_currentSessionGameQuery whereKey:@"session" equalTo:_currentSession];
    
    //Go Fetch Data
    [_currentSessionGameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            //Store query on clientSide within NSMutableArray
            _clientSideGamesArray = [NSMutableArray arrayWithArray:objects];
            
            [[self tableView] reloadData];
        } else {
            NSLog(@"Querry error for fetching games");
        }
    }];
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    //NSLog(@"Callback Will!");
    
    NSLog(@"%@", [NSString stringWithFormat:@"Alert Button Index: %ld", (long)buttonIndex]);
    
    if(buttonIndex != 0) {
        //Retrive text from textfield and assign to pointer
        NSString * gameTitle = [[alertView textFieldAtIndex: 0] text];
        
        //Create new game object
        PFObject * newGame = [PFObject objectWithClassName:@"Game"];
        
        //Set title attribute for object
        [newGame setObject:gameTitle forKey:@"title"];
        
        // Create relationship
        [newGame setObject:_currentSession forKey:@"session"];
        
        [newGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error) {
                
                //Call query method
                [self findGamesAssociatedWithSession];
            
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            };
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //NSLog(@"Callback Did!");
    [[self tableView] reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
