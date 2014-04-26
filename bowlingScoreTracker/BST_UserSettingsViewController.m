//
//  BST_UserSettingsViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 3 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
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
    
    //Add gesture recognizer to dismiss modal keyboard
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
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

#pragma mark - Resign Keyboard Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void) resignOnTap:(id)sender {
    [[self view] endEditing:YES];
}


#pragma mark - Custom Methods

- (IBAction)saveUserChanges:(id)sender {
    
    //Capture text from textfields and store within NSString pointers
    NSString * userNameText             =  [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * emailText                =  [self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * firstNameText            =  [self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * lastNameText             =  [self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * passwordText             =  [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSNumber * handedNessValue          =  [NSNumber numberWithInteger:_handedNess.selectedSegmentIndex];
    NSString * handedNessValueString    =  [NSString stringWithFormat:@"%@", handedNessValue];
    
    //Test if fields are left empty
    if([userNameText length] == 0 || [passwordText length] == 0 || [firstNameText length] == 0 || [lastNameText length] == 0 || [emailText length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"Make sure you enter a username, email address, first name, last name and password."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } else /*Do action*/ {
        NSLog(@"Send data to parse");
        
        //Check against existing user through FB Sign up
        PFUser * currentBowler = [PFUser currentUser];
        
        if(currentBowler != nil){
            
            // Grab textField values and assign to userObject
            currentBowler.username          = userNameText;
            currentBowler.email             = emailText;
            currentBowler[@"firstname"]     = firstNameText;
            currentBowler[@"lastname"]      = lastNameText;
            currentBowler[@"handedNess"]    = handedNessValueString;
            
            [currentBowler saveEventually:^(BOOL succeeded, NSError *error) {
                if (error) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                }
                else {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Settings Saved"
                                                                        message:@"Your user settings have been saved."
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                }
            }];
            
        }
    }
    
}

// Action for triggering confirm for deleteAccount
- (IBAction)deleteUserAccount:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Account"
                                                        message:@"We're sorry to see you go. Are you sure you want to delete your account?"
                                                       delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alertView show];
    
}


// Delete Account Method targeted from uiAlertView
-(void) deleteAcount {
    
    //Perform delete method
    [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"Delete Account error'd");
        } else {
            [self performSegueWithIdentifier:@"deleteUserAccount" sender:nil];
        }
    }];
    
}

#pragma mark - UIAlertView Delegate Methods

// Determine which uiAlertViewButton was clicked for confirm deleteAccount
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //NSLog(@"You clicked yes");
        [self deleteAcount];
        
    } else if (buttonIndex == 1) {
        
    }
    
}

#pragma mark - Navigation

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
