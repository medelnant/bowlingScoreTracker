//
//  BST_SessionDetailViewController.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
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

//Define IBOutlets for all UI Elements
@property (weak, nonatomic) IBOutlet UILabel *summaryStrikeCount;
@property (weak, nonatomic) IBOutlet UILabel *summarySpareCount;
@property (weak, nonatomic) IBOutlet UILabel *summarySinglePinLeaves;
@property (weak, nonatomic) IBOutlet UILabel *summarySinglePinSpares;
@property (weak, nonatomic) IBOutlet UILabel *totalSeries;
@property (weak, nonatomic) IBOutlet UILabel *totalAverage;

- (void) sendPost;
- (void) gatherReportData;

@end
