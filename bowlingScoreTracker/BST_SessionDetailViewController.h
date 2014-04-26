//
//  BST_SessionDetailViewController.h
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/25/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController/SWRevealViewController.h"


@interface BST_SessionDetailViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property NSMutableDictionary * detailedSession;

@end
