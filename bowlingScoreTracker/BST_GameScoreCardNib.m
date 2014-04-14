//
//  BST_GameScoreCardNib.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_GameScoreCardNib.h"

@implementation BST_GameScoreCardNib

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"GameScoreCard" owner:self options:nil];
        [self addSubview:_mainView];
        
        
        //Define throw label grouping
        _frames = @[ /*Frame 1*/   @[_throw_1,   _throw_2],
                     /*Frame 2*/   @[_throw_3,   _throw_4],
                     /*Frame 3*/   @[_throw_5,   _throw_6],
                     /*Frame 4*/   @[_throw_7,   _throw_8],
                     /*Frame 5*/   @[_throw_9,   _throw_10],
                     /*Frame 6*/   @[_throw_11,  _throw_12],
                     /*Frame 7*/   @[_throw_13,  _throw_14],
                     /*Frame 8*/   @[_throw_15,  _throw_16],
                     /*Frame 9*/   @[_throw_17,  _throw_18],
                     /*Frame 10*/  @[_throw_19,  _throw_20,   _throw_21]];
        
        
        //Define frame total label grouping
        _frameTotals = @[ /*Frame 1*/   _frameTotal_1,
                          /*Frame 2*/   _frameTotal_2,
                          /*Frame 3*/   _frameTotal_3,
                          /*Frame 4*/   _frameTotal_4,
                          /*Frame 5*/   _frameTotal_5,
                          /*Frame 6*/   _frameTotal_6,
                          /*Frame 7*/   _frameTotal_7,
                          /*Frame 8*/   _frameTotal_8,
                          /*Frame 9*/   _frameTotal_9,
                          /*Frame 10*/   _frameTotal_10];
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

@end
