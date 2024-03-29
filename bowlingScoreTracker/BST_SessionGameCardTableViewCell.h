//
//  BST_SessionGameCardTableViewCell.h
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

@interface BST_SessionGameCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property (weak, nonatomic) IBOutlet UILabel *gameScore;

@property (strong, nonatomic) NSArray * frames;
@property (strong, nonatomic) NSArray * frameTotals;

//Summary Labels


//Throws
@property (weak, nonatomic) IBOutlet UILabel *throw_1;
@property (weak, nonatomic) IBOutlet UILabel *throw_2;
@property (weak, nonatomic) IBOutlet UILabel *throw_3;
@property (weak, nonatomic) IBOutlet UILabel *throw_4;
@property (weak, nonatomic) IBOutlet UILabel *throw_5;
@property (weak, nonatomic) IBOutlet UILabel *throw_6;
@property (weak, nonatomic) IBOutlet UILabel *throw_7;
@property (weak, nonatomic) IBOutlet UILabel *throw_8;
@property (weak, nonatomic) IBOutlet UILabel *throw_9;
@property (weak, nonatomic) IBOutlet UILabel *throw_10;
@property (weak, nonatomic) IBOutlet UILabel *throw_11;
@property (weak, nonatomic) IBOutlet UILabel *throw_12;
@property (weak, nonatomic) IBOutlet UILabel *throw_13;
@property (weak, nonatomic) IBOutlet UILabel *throw_14;
@property (weak, nonatomic) IBOutlet UILabel *throw_15;
@property (weak, nonatomic) IBOutlet UILabel *throw_16;
@property (weak, nonatomic) IBOutlet UILabel *throw_17;
@property (weak, nonatomic) IBOutlet UILabel *throw_18;
@property (weak, nonatomic) IBOutlet UILabel *throw_19;
@property (weak, nonatomic) IBOutlet UILabel *throw_20;
@property (weak, nonatomic) IBOutlet UILabel *throw_21;

//Frame Totals
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_1;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_2;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_3;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_4;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_5;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_6;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_7;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_8;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_9;
@property (weak, nonatomic) IBOutlet UILabel *frameTotal_10;


@end
