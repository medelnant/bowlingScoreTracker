//
//  BST_SessionCardTableViewCell.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/30/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BST_SessionCardTableViewCell : UITableViewCell

//Define all IBOulets for UI Elements
@property (weak, nonatomic) IBOutlet UILabel *sessionTitle;
@property (weak, nonatomic) IBOutlet UILabel *sessionVenue;
@property (weak, nonatomic) IBOutlet UILabel *sessionDate;
@property (weak, nonatomic) IBOutlet UILabel *sessionNumberOfGames;
@property (weak, nonatomic) IBOutlet UILabel *sessionSeries;
@property (weak, nonatomic) IBOutlet UILabel *sessionAverage;


@end
