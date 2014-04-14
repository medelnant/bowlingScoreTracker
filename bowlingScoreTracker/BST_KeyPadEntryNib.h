//
//  BST_KeyPadEntryNib.h
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyPadEntryViewDelegate <NSObject>
-(void) keyPadPressed:(NSInteger)buttonTagIndex forButtonTitle:(NSString*)buttonTitle;
@end

@interface BST_KeyPadEntryNib : UIView
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *strikeSpareButton;

@property (strong, nonatomic) id <KeyPadEntryViewDelegate> delegate;

- (IBAction)keyPadTouched:(UIButton *)sender;
@end
