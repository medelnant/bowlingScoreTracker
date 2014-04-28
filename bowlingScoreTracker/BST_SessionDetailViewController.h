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
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

- (void) gatherReportData;

@property (weak, nonatomic) IBOutlet UILabel *summaryStrikeCount;
@property (weak, nonatomic) IBOutlet UILabel *summarySpareCount;
@property (weak, nonatomic) IBOutlet UILabel *summarySinglePinLeaves;
@property (weak, nonatomic) IBOutlet UILabel *summarySinglePinSpares;

@end
