//
//  BST_PinPadEntryNib.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 3 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_PinPadEntryNib.h"

@implementation BST_PinPadEntryNib

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"PinPadEntry" owner:self options:nil];
        [self addSubview:_mainView];
        
        //FrameLabels
        _pins = @[/*Pin 1*/     _pinBtn_1,
                  /*Pin 2*/     _pinBtn_2,
                  /*Pin 3*/     _pinBtn_3,
                  /*Pin 4*/     _pinBtn_4,
                  /*Pin 5*/     _pinBtn_5,
                  /*Pin 6*/     _pinBtn_6,
                  /*Pin 7*/     _pinBtn_7,
                  /*Pin 8*/     _pinBtn_8,
                  /*Pin 9*/     _pinBtn_9,
                  /*Pin 10*/    _pinBtn_10];
        
        //Set Pin Default Text Colors and Background Image
        [_pins[0] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[0] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[1] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[1] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[2] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[2] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[3] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[3] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[4] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[4] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[5] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[5] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[6] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[6] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[7] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[7] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[8] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[8] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [_pins[9] setBackgroundImage:[UIImage imageNamed:@"pinButton_off.png" ] forState:UIControlStateNormal];
        [_pins[9] setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        
        //Set Pin Select Text Colors and Background Image
        [_pins[0] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[0] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[1] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[1] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[2] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[2] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[3] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[3] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[4] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[4] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[5] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[5] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[6] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[6] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[7] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[7] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[8] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[8] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [_pins[9] setBackgroundImage:[UIImage imageNamed:@"pinButton_on.png" ] forState:UIControlStateSelected];
        [_pins[9] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
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

- (IBAction)PinPadTouched:(UIButton *)sender {
    [_delegate pinPadPressed:[sender tag] forButtonTitle:[sender currentTitle]];
    
    if(sender.tag <= 9) {
        if([_pins[sender.tag] isSelected] == YES) {
            [_pins[sender.tag] setSelected:NO];
        } else {
            [_pins[sender.tag] setSelected:YES];
        }
    }

}

@end
