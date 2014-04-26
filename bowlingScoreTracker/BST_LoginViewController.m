//
//  BST_LoginViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 3 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_LoginViewController.h"


@interface BST_LoginViewController ()

@end

@implementation BST_LoginViewController 

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

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)forgotPassword:(id)sender {
    NSLog(@"Forgot Password Clicked!");
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

#pragma mark - segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loggedIn"])
    {
        //BST_LoggedInViewController *dvc = [segue destinationViewController];
    }
}

@end
