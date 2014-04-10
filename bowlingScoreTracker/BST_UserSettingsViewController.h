//
//  BST_UserSettingsViewController.h
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SWRevealViewController.h"
#import "BST_MenuTableViewController.h"

@interface BST_UserSettingsViewController : UIViewController

// Define UI components
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UISegmentedControl *handedNess;


//Define IBActions
- (IBAction)saveUserChanges:(id)sender;
- (IBAction)deleteUserAccount:(id)sender;

//Delete account method
-(void) deleteAcount;

@end
