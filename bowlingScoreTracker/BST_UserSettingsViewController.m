//
//  BST_UserSettingsViewController.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_UserSettingsViewController.h"

@interface BST_UserSettingsViewController ()

@end

@implementation BST_UserSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Add gesture for swiping within navBar to trigger drawer slide open/close
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    //Set View Title
    self.navigationItem.title = @"User Settings";
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self.revealViewController action:@selector( revealToggle: )];
    
    // If currentBowler exists (which it absolutely should for this screen)
    PFUser * currentBowler = [PFUser currentUser];
    if (currentBowler != nil) {
        
        // Set textfield text values
        self.username.text      = currentBowler.username;
        self.email.text         = currentBowler.email;
        self.firstName.text     = [currentBowler objectForKey:@"firstname"];
        self.lastName.text      = [currentBowler objectForKey:@"lastname"];
        
        //Set appropriate selection based on data sent back from parse for handedNess segmentedControl
        if([[currentBowler objectForKey:@"handedNess"] isEqualToString:@"1"]) {
            _handedNess.selectedSegmentIndex = 1;
        } else {
            _handedNess.selectedSegmentIndex = 2;
        }
        
        //Set username to disabled and change textColor
        self.username.enabled = NO;
        self.username.textColor = [UIColor grayColor];
        
        //Set password to disabled since its not needed, set value to null, change textColor
        self.password.enabled = NO;
        self.password.text = @"null";
        self.password.textColor = [UIColor grayColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveUserChanges:(id)sender {
}

// Action for triggering confirm for deleteAccount
- (IBAction)deleteUserAccount:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setTitle:@"Delete Account"];
    [alertView setMessage:@"We're sorry to see you go. Are you sure you want to delete your account?"];
    [alertView setDelegate:self];
    [alertView addButtonWithTitle:@"Yes"];
    [alertView addButtonWithTitle:@"No"];
    [alertView show];
}

// Determine which uiAlertViewButton was clicked for confirm deleteAccount
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"You clicked yes!");
        [self deleteAcount];
        
    } else if (buttonIndex == 1) {
    
    }
}

// Delete Account Method targeted from uiAlertView
-(void) deleteAcount {
    NSLog(@"Delete Account hit!");
    [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"Delete Account error'd");
        } else {
            [self performSegueWithIdentifier:@"deleteUserAccount" sender:nil];
        }
    }];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeftSideMost animated: YES];
        };
        
    }
    
}



@end
