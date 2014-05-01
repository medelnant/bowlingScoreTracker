//
//  BST_UserSettingsViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_UserSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BST_UserSettingsViewController ()

@end

@implementation BST_UserSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //Styling
    [self.view setBackgroundColor: [UIColor colorWithRed:0.84 green:0.83 blue:0.85 alpha:1]];
    
    
    //UserName Field
    _username.backgroundColor = [UIColor clearColor];
    _username.layer.borderWidth = 1.0f;
    _username.layer.cornerRadius = 0.0f;
    _username.layer.borderColor = [[UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:0.5]CGColor];
    _username.layer.masksToBounds = YES;
    _username.layer.backgroundColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f]CGColor];
    _username.textColor = [UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:1];
    
    //Email Field
    _email.backgroundColor = [UIColor clearColor];
    _email.layer.borderWidth = 1.0f;
    _email.layer.cornerRadius = 0.0f;
    _email.layer.borderColor = [[UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:0.5]CGColor];
    _email.layer.masksToBounds = YES;
    _email.layer.backgroundColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f]CGColor];
    _email.textColor = [UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:1];
    
    //First Name Field
    _firstName.backgroundColor = [UIColor clearColor];
    _firstName.layer.borderWidth = 1.0f;
    _firstName.layer.cornerRadius = 0.0f;
    _firstName.layer.borderColor = [[UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:0.5]CGColor];
    _firstName.layer.masksToBounds = YES;
    _firstName.layer.backgroundColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f]CGColor];
    _firstName.textColor = [UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:1];
    
    //Last Name Field
    _lastName.backgroundColor = [UIColor clearColor];
    _lastName.layer.borderWidth = 1.0f;
    _lastName.layer.cornerRadius = 0.0f;
    _lastName.layer.borderColor = [[UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:0.5]CGColor];
    _lastName.layer.masksToBounds = YES;
    _lastName.layer.backgroundColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f]CGColor];
    _lastName.textColor = [UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:1];
    
    //Password Field
    _password.backgroundColor = [UIColor clearColor];
    _password.layer.borderWidth = 1.0f;
    _password.layer.cornerRadius = 0.0f;
    _password.layer.borderColor = [[UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:0.5]CGColor];
    _password.layer.masksToBounds = YES;
    _password.layer.backgroundColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f]CGColor];
    _password.textColor = [UIColor colorWithRed:0.21 green:0.2 blue:0.27 alpha:1];
    
    
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
    self.navigationItem.title = @"User Settings";
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationMenuIcon.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector( revealToggle: )];
    
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
