//
//  BST_LoginViewController.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 2 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BST_LoggedInViewController.h"

@interface BST_LoginViewController : UIViewController <UITextFieldDelegate>

// Define UI Properties
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

// Define IBActions
- (IBAction)forgotPassword:(id)sender;
- (IBAction)loginUser:(id)sender;
- (IBAction)faceBookRegisterUser:(id)sender;
- (IBAction)registerUser:(id)sender;

//Define custom methods

//Resign Keyboard on tap
- (void)resignOnTap: (id)sender;

@end
