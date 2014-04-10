//
//  BST_SessionsTableViewController.h
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/9/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController/SWRevealViewController.h"


@interface BST_SessionsTableViewController : UITableViewController

//Store returned data from query within NSMutableArray
@property NSMutableArray * clientSideSessionArray;

//Define query and object for passing to other view controllers
@property PFObject * createdSession;
@property PFQuery *sessionQuery;

//Add Session Method
- (void)addSession;

//Add Session Method
- (void)deleteSession:(NSInteger)sessionIndex;
@end

