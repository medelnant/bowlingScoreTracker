//
//  BST_PinPadEntryNib.h
//  bowlingScoreTracker
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


//Define delegate reference
@property (strong, nonatomic) id <PinPadEntryViewDelegate> delegate;

- (IBAction)PinPadTouched:(UIButton *)sender;


@end
