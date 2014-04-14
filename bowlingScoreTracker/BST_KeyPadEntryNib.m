//
//  BST_KeyPadEntryNib.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_KeyPadEntryNib.h"

@implementation BST_KeyPadEntryNib

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"KeyPadEntry" owner:self options:nil];
        [self addSubview:_mainView];
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
