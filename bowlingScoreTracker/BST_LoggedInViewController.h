//
//  BST_LoggedInViewController.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"


@interface BST_LoggedInViewController : UIViewController

// Define navigation button for reveal side drawer
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;

- (IBAction)logUserOut:(id)sender;

@end
