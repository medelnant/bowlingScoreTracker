//
//  BST_SignUpViewController.h
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

@interface BST_SignUpViewController : UIViewController <UITextFieldDelegate>

// Define UI Properties
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UISegmentedControl *handedNess;

// Define IBActions
- (IBAction)registerUser:(id)sender;

//Define Custom Methods

//Resign Keyboard on tap
- (void)resignOnTap: (id)sender;

@end
