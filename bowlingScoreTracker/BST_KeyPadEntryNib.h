//
//  BST_KeyPadEntryNib.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 3 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyPadEntryViewDelegate <NSObject>
-(void) keyPadPressed:(NSInteger)buttonTagIndex forButtonTitle:(NSString*)buttonTitle;
@end

@interface BST_KeyPadEntryNib : UIView

@property (strong, nonatomic) NSArray * keyPadButtons;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *strikeSpareButton;
@property (weak, nonatomic) IBOutlet UIButton *splitButton;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *foulButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroButton;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UIButton *sixButton;
@property (weak, nonatomic) IBOutlet UIButton *sevenButton;
@property (weak, nonatomic) IBOutlet UIButton *eightButton;
@property (weak, nonatomic) IBOutlet UIButton *nineButton;






@property (strong, nonatomic) id <KeyPadEntryViewDelegate> delegate;

- (IBAction)keyPadTouched:(UIButton *)sender;
@end
