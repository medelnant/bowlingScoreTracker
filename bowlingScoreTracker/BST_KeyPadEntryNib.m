//
//  BST_KeyPadEntryNib.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_KeyPadEntryNib.h"
#import <QuartzCore/QuartzCore.h>

@implementation BST_KeyPadEntryNib

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"KeyPadEntry" owner:self options:nil];
        [self addSubview:_mainView];
        
        _keyPadButtons = @[_strikeSpareButton,
                           _splitButton,
                           _clearButton,
                           _foulButton,
                           _zeroButton,
                           _oneButton,
                           _twoButton,
                           _threeButton,
                           _fourButton,
                           _fiveButton,
                           _sixButton,
                           _sevenButton,
                           _eightButton,
                           _nineButton];
        
        //Set Styles for buttons
        for (NSInteger i = 0; i<_keyPadButtons.count; i++) {
            [_keyPadButtons[i] setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
            [_keyPadButtons[i] setTitleColor:[UIColor colorWithRed:0.24 green:0.23 blue:0.33 alpha:1] forState:UIControlStateNormal];
            [_keyPadButtons[i] setTitleColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1] forState:UIControlStateHighlighted];
            [_keyPadButtons[i] setTitleColor:[UIColor colorWithRed:0.84 green:0.83 blue:0.85 alpha:1] forState:UIControlStateDisabled];
            [_keyPadButtons[i] setTitleShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.5] forState:UIControlStateNormal];
            [[_keyPadButtons[i] layer] setBorderWidth:2.0f];
            [[_keyPadButtons[i] layer] setBorderColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:.15].CGColor];
            
            if([_keyPadButtons[i] isSelected]) {
                [[_keyPadButtons[i] layer] setBorderColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1].CGColor];
            }
        }
        
        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)keyPadTouched:(UIButton *)sender {
    [_delegate keyPadPressed:[sender tag] forButtonTitle:[sender currentTitle]];
}
@end
