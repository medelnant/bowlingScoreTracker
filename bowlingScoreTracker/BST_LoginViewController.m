//
//  BST_LoginViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_LoginViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface BST_LoginViewController ()

@end

@implementation BST_LoginViewController 

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    NSLog(@"Back to main login screen!");
    
    //Check if user exists
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self performSegueWithIdentifier:@"loggedIn" sender:nil];
    }
    
    //Styling
    self.view.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.21 alpha:1];
    
    //Set Placeholder color to UITextFields
    _username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.31 green:0.3 blue:0.43 alpha:1]}];
    _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.31 green:0.3 blue:0.43 alpha:1]}];
    
    //UserName Field
    _username.layer.borderWidth = 0.0f;
    _username.layer.masksToBounds = YES;
    _username.layer.backgroundColor = [[UIColor uiTextfieldBackground]CGColor];
    _username.textColor = [UIColor colorWithRed:0.84 green:0.83 blue:0.85 alpha:1];
    
    //Password Field
    _password.layer.borderWidth = 0.0f;
    _password.layer.masksToBounds = YES;
    _password.layer.backgroundColor = [[UIColor uiTextfieldBackground] CGColor];
    _password.textColor = [UIColor colorWithRed:0.84 green:0.83 blue:0.85 alpha:1];
    
    //Set NavigationController Colors
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]}];
    
    _createAccountButton.layer.borderWidth = 1.0f;
    _createAccountButton.layer.masksToBounds = YES;
    _createAccountButton.layer.borderColor = [[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1] CGColor];
    
    [[self.navigationController.navigationBar viewWithTag:66] removeFromSuperview];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1];
    
    //Add Bottom Border to NavigationBar
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height-2,self.navigationController.navigationBar.frame.size.width, 2)];
    navBorder.tag = 55;
    [navBorder setBackgroundColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]];
    [navBorder setOpaque:YES];
    [self.navigationController.navigationBar addSubview:navBorder];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)forgotPassword:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot Password"
                                                        message:@"Please provide your email address to receive a reset link for your password"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 99;
    [alertView show];
}

- (IBAction)loginUser:(id)sender {
    NSLog(@"Log In Clicked!");
    
    //Capture text from textfields and store within NSString pointers
    NSString * userNameText     = [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * passwordText     = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Test if fields are left empty
    if([userNameText length] == 0 || [passwordText length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username and password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else /*Do Action*/{
        NSLog(@"Send data to parse");
        
        //Perform logggin method for user
        [PFUser logInWithUsernameInBackground:userNameText password:passwordText block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                
                //Clear fields
                self.username.text = @"";
                self.password.text = @"";
                
                //Send to loggedInView
                [self performSegueWithIdentifier:@"loggedIn" sender:nil];
            }
        }];

    }
}

- (IBAction)faceBookRegisterUser:(id)sender {
    NSLog(@"Facebook Clicked!");
    
    //Perform loggin method for user via facebook
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self performSegueWithIdentifier:@"signUp" sender:nil];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self performSegueWithIdentifier:@"loggedIn" sender:nil];
        }
    }];
    
}

- (IBAction)registerUser:(id)sender {
    NSLog(@"Sign Up Clicked!");
}

-(void) resignOnTap:(id)sender {
    [[self view] endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //NSLog(@"Callback Did!");
    
    NSLog(@"%@", [NSString stringWithFormat:@"Alert Button Index: %ld", (long)buttonIndex]);
    
    if(buttonIndex != 0) {
        if (alertView.tag == 99) {
            
            //Retrive text from textfield and assign to pointer
            NSString * emailAddress = [[alertView textFieldAtIndex: 0] text];
            
            [PFUser requestPasswordResetForEmailInBackground:emailAddress block:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password Reset Email Sent"
                                                                        message:@"An email will arrive shortly that will allow for you to reset your password."
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
            }];
            
            
        }
    }

}

#pragma mark - segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loggedIn"])
    {
        //BST_LoggedInViewController *dvc = [segue destinationViewController];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
