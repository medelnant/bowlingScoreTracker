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

@property NSMutableArray * clientSessionArray;
@property PFObject * createdSession;
@property PFQuery *sessionQuery;


//Add Session Method
- (void)addSession;
@end

