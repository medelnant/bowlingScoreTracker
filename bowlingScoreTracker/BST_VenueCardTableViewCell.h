//
//  BST_VenueCardTableViewCell.h
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

@interface BST_VenueCardTableViewCell : UITableViewCell

//Define all IBOutlets for UI Elements
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *venueLocation;

@end
