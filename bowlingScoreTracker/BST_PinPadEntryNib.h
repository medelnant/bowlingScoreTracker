//
//  BST_PinPadEntryNib.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>

//Define delegate protocal with available methods
@protocol PinPadEntryViewDelegate <NSObject>
-(void) pinPadPressed:(NSInteger)buttonTagIndex forButtonTitle:(NSString*)buttonTitle;
@end

@interface BST_PinPadEntryNib : UIView
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *strikeSpareButton;
@property (weak, nonatomic) IBOutlet UIButton *splitButton;
@property (weak, nonatomic) IBOutlet UIButton *foulButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;


//Pin Group
@property (strong, nonatomic) NSArray * pins;

//Button Group
@property (strong, nonatomic) NSArray * buttons;

//Pin Buttons
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_3;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_4;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_5;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_6;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_7;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_8;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_9;
@property (weak, nonatomic) IBOutlet UIButton *pinBtn_10;



//Define delegate reference
@property (strong, nonatomic) id <PinPadEntryViewDelegate> delegate;

- (IBAction)PinPadTouched:(UIButton *)sender;



@end
