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

@property (strong, nonatomic) NSArray * keyPadButton;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *strikeSpareButton;
@property (weak, nonatomic) IBOutlet UIButton *splitButton;


@property (strong, nonatomic) id <KeyPadEntryViewDelegate> delegate;

- (IBAction)keyPadTouched:(UIButton *)sender;
@end
