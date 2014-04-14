//
//  BST_GameScoringViewController.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_GameScoringViewController.h"


@interface BST_GameScoringViewController ()

@end

@implementation BST_GameScoringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add gesture for swiping within navBar to trigger drawer slide open/close
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    //Set View Title
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Game 1", [_currentSession valueForKey:@"title"]];
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self.revealViewController action:@selector( revealToggle: )];
    
     _scoreCardView = [[BST_GameScoreCardNib alloc] initWithFrame:CGRectMake(0, 0, 670, 90)];
    
    //Needed to due mystery insets applied when using with storyBoard and navigationController. (Annoying)
    self.automaticallyAdjustsScrollViewInsets = NO;

    //Set Scroll View Size to nib view dimensions
    [_scoreCardScrollView setContentSize:CGSizeMake(_scoreCardView.frame.size.width, _scoreCardScrollView.frame.size.height)];
    //Add View to scroll view
    [_scoreCardScrollView addSubview: _scoreCardView];
    
    
    BST_KeyPadEntryNib * numberEntryView = [[BST_KeyPadEntryNib alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    numberEntryView.delegate = self;
    //Add View to scoringEntry view
    [_scorePadEntryView addSubview: numberEntryView];
    
    //Set overallFrameCounter
    overallFrameCounter = 0;
    
    //Set frameThrowCount & maxFrameThrowCount
    frameThrowCount = 1;
    maxFrameThrowCount = 2;
    
    [self clearGameScoring];
    _activeGameScoreArray = [self createEmptyGameArray];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KeyPadEntry Delegate Methods

-(void) keyPadPressed:(NSInteger)buttonTagIndex forButtonTitle:(NSString*)buttonTitle {
    //NSLog(@"Parent View Controller - %@ clicked with tag: %ld",buttonTitle,(long)buttonTagIndex);
    //NSLog(@"activeFameScoreArray looks like: %lu", (unsigned long)_activeGameScoreArray.count);
    
    if([buttonTitle isEqualToString:@"Foul"]) {
        _throwCountLabel.text = buttonTitle;
        [self addThrowCountToGameObject:@"0"];
    } else if ([buttonTitle isEqualToString:@"Clear"]) {
        _throwCountLabel.text = @"";
        NSLog(@"Clear Frame Pressed");
    } else if ([buttonTitle isEqualToString:@"Split"]) {
        NSLog(@"Split Indicator Pressed");
    } else {
        _throwCountLabel.text = buttonTitle;
    }
    
    //Make call to addThrowCountToGameObject
}

#pragma mark - PinPadEntry Delegate Methods

- (void)pinPadPressed:(NSInteger)buttonTagIndex forButtonTitle:(NSString*)buttonTitle {
    //NSLog(@"Parent View Controller - %@ clicked with tag: %ld",buttonTitle,(long)buttonTagIndex);
    //NSLog(@"CurrentGameArray looks like: %@", _activeGameScoreArray);
    
    if([buttonTitle isEqualToString:@"Foul"]) {
        _throwCountLabel.text = buttonTitle;
        [self addThrowCountToGameObject:@"0"];
    } else if ([buttonTitle isEqualToString:@"Clear"]) {
        _throwCountLabel.text = @"";
        NSLog(@"Clear Frame Pressed");
    } else if ([buttonTitle isEqualToString:@"Split"]) {
        NSLog(@"Split Indicator Pressed");
    } else {
        _throwCountLabel.text = buttonTitle;
    }
}

#pragma mark - Custom Methods

- (void)calculateGameScore {
    
    //NSLog(@"My Updated Game Array : %@", _activeGameScoreArray);
    
    int gameTotal = 0;
    
    for (NSInteger i = 0; i < _activeGameScoreArray.count; i++) {
        
        NSString * frameThrowCount1 = [_activeGameScoreArray[i] valueForKey:@"throw1"];
        NSString * frameThrowCount2 = [_activeGameScoreArray[i] valueForKey:@"throw2"];
        
        if([frameThrowCount1 isEqualToString:@""] && [frameThrowCount2 isEqualToString:@""]) {
            [_scoreCardView.frameTotals[i] setText:@""];
        } else {
            int frameTotal = ([frameThrowCount1 intValue] + [frameThrowCount2 intValue]);
            gameTotal = gameTotal + frameTotal;
            [_scoreCardView.frameTotals[i] setText:[NSString stringWithFormat:@"%d", gameTotal]];
            [_activeGameScoreArray[i] setValue:[NSString stringWithFormat:@"%d", gameTotal] forKey:@"frameTotal"];
        }
    }
    
    //Update scoreboard based on activeGameScoreArray
    [self updateScoreCard];
}


- (void)updateScoreCard {
    
    //NSLog(@"My Updated Game Array : %@", _activeGameScoreArray);
    
    for (NSInteger i = 0; i < _activeGameScoreArray.count; i++) {
        
        NSLog(@"Frames count within array = %lu", (unsigned long)[_scoreCardView.frames[i] count]);
        
        if([_scoreCardView.frames[i] count] > 2) {
            NSString * frameThrowCount1 = [_activeGameScoreArray[i] valueForKey:@"throw1"];
            NSString * frameThrowCount2 = [_activeGameScoreArray[i] valueForKey:@"throw2"];
            NSString * frameThrowCount3 = [_activeGameScoreArray[i] valueForKey:@"throw3"];
            
            [_scoreCardView.frames[i][0] setText:frameThrowCount1];
            [_scoreCardView.frames[i][1] setText:frameThrowCount2];
            [_scoreCardView.frames[i][2] setText:frameThrowCount3];
            
        } else {
            NSString * frameThrowCount1 = [_activeGameScoreArray[i] valueForKey:@"throw1"];
            NSString * frameThrowCount2 = [_activeGameScoreArray[i] valueForKey:@"throw2"];
            
            [_scoreCardView.frames[i][0] setText:frameThrowCount1];
            [_scoreCardView.frames[i][1] setText:frameThrowCount2];
        }
        
        
    
    }
    
    
    NSLog(@"My Game Array : %@", _activeGameScoreArray[overallFrameCounter]);
}

- (void)clearGameScoring {
    _frameStatusLabel.text  = @"Frame 1";
    _throwCountLabel.text   = @"";
    
    //Clear scorecard
    [self clearGameScoreCard];
}

- (void)clearGameScoreCard {
    
    int i;
    
    //Clear throws
    for (i=0; i <= 20; i++) {
        //[_scoreCardView.throws[i] setText:@""];
    };
    
    //Clear frame totals
    for (i=0; i <= 9; i++) {
        [_scoreCardView.frameTotals[i] setText:@""];
    };
    
}

- (void)addThrowCountToGameObject:(NSString*)throwCount {
    
    //NSLog(@"addThrowCountToGameObject value passed is : %@", throwCount);
    
    //Decode Strike to pin count and send pin count and advance to next frame
    if([throwCount isEqualToString:@"X"]) {
        //Send correct pin count
        
        if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
            
            NSLog(@"Adding tenth frame throws");
            NSString * tenthFrameThrow = [NSString stringWithFormat:@"throw%d", frameThrowCount];
            [_activeGameScoreArray[overallFrameCounter] setObject:throwCount forKey:tenthFrameThrow];

        } else {
            
            //Anyother frame but the tenth frame
            [_activeGameScoreArray[overallFrameCounter] setObject:throwCount forKey:@"throw1"];
            [_activeGameScoreArray[overallFrameCounter] setObject:@"" forKey:@"throw2"];
            [_activeGameScoreArray[overallFrameCounter] setObject:@"true" forKey:@"isStrike"];
            
        }
        
    } else {
        //When not a strike
        [_activeGameScoreArray[overallFrameCounter] setObject:throwCount forKey:[NSString stringWithFormat:@"throw%d", frameThrowCount]];
    }
    
    if([[_activeGameScoreArray[overallFrameCounter] valueForKey:@"isStrike"] isEqualToString:@"true"] || frameThrowCount == 2) {
        [self calculateGameScore];
    } else {
        [self updateScoreCard];
    }
    
    

}

- (NSMutableArray*)createEmptyGameArray {

    NSLog(@"CreateEmptyGameArray called!");
    //Build array to 21 throws (accounting for index 0)
    NSMutableArray *gameArray = [[NSMutableArray alloc]init];
    
    //Create 10 frames
    for (NSInteger i = 0; i <= 9; i++) {
        
        //With NSMutableDictionary containing frame throws and bool checks
        NSMutableDictionary * frame = [[NSMutableDictionary alloc] init];
        [frame setValue:@"" forKey:@"throw1"];
        [frame setValue:@"" forKey:@"throw2"];
        [frame setValue:@"false" forKey:@"isStrike"];
        [frame setValue:@"false" forKey:@"isSpare"];
        [frame setValue:@"" forKey:@"frameTotal"];
        
        //Add third throw for 10th frame
        if(i == 9) {
            [frame setValue:@"" forKey:@"throw3"];
        }
        
        //Add NSMutableDictionary to NSMutableArray
        [gameArray addObject:frame];
    }
    return gameArray;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)scoringEntryOptionValueChanged:(UISegmentedControl *)sender {
    
    long index = sender.selectedSegmentIndex;
    
    if(index == 0) {
        BST_KeyPadEntryNib * numberEntryView = [[BST_KeyPadEntryNib alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        numberEntryView.delegate = self;
        //Add View to scoringEntry view
        [_scorePadEntryView addSubview: numberEntryView];
    } else {
        BST_PinPadEntryNib * pinEntryView = [[BST_PinPadEntryNib alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        pinEntryView.delegate = self;
        //Add View to scoringEntry view
        [_scorePadEntryView addSubview: pinEntryView];
        
    }
    
}

- (IBAction)gameFrameNavigation:(UIButton *)sender {
    
    long index = sender.tag;
    
    if(index == 0) {
        
        if(overallFrameCounter > 0) {
            overallFrameCounter--;
        }
        
        if(overallFrameCounter <= 5) {
            [_scoreCardScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }

        NSLog(@"User clicked on previous frame button");
    } else {
        
        if (![_throwCountLabel.text  isEqual: @""]) {
            if(frameThrowCount == maxFrameThrowCount) {
                
                NSLog(@"------------------------------------------------");
                NSLog(@"Option 1 Overall Frame Count = %d out of %lu", overallFrameCounter, (unsigned long)_activeGameScoreArray.count-1);

                // If second throw causes frame total to exceed 10
                if ([_throwCountLabel.text intValue] > (10 - firstFramePinCount)) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                        message:@"You cannot enter a pin value that will cause frame total to exceed 10"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    //Send user throw count to addThrowCountToGameObject
                    [self addThrowCountToGameObject:_throwCountLabel.text];
                    
                    //Clear throw count label
                    _throwCountLabel.text = @"";
                    
                    NSLog(@"Overall Frame Throw Count = %d", frameThrowCount);
                    NSLog(@"Overall Max Frame Throw Count = %d", maxFrameThrowCount);
                    
                    //Reset firstFramePinCount
                    firstFramePinCount = 0;
                    
                    if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
                        NSLog(@"Test Advance Click Next: %d out of %lu", overallFrameCounter, (_activeGameScoreArray.count -1));
                        maxFrameThrowCount = 3;
                    } else {
                        //Advance to next frame
                        overallFrameCounter++;
                        
                        //Default frameThrowCount to 1
                        frameThrowCount = 1;
                        
                    }
                    
                    //Change frameStatusLabel to appropriate frame
                    _frameStatusLabel.text = [NSString stringWithFormat:@"Frame %d", (overallFrameCounter+1)];
                }
                

                
                NSLog(@"------------------------------------------------");
                
            } else {
                
                NSLog(@"------------------------------------------------");
                NSLog(@"Option 2 Overall Frame Count = %d out of %lu", overallFrameCounter, ((unsigned long)_activeGameScoreArray.count-1));
                
                //Set Frame firstThrowPinCount
                firstFramePinCount = [_throwCountLabel.text intValue];
                
                //Send user throw count to addThrowCountToGameObject
                [self addThrowCountToGameObject:_throwCountLabel.text];

                
                //If we're dealing with a strike
                if([_throwCountLabel.text isEqualToString:@"X"]) {
                    
                    firstFramePinCount = 10;
                    
                    //If 10th frame lets not advance frames anymore
                    if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
                        NSLog(@"Test Advance Click Next: %d out of %lu", overallFrameCounter, (_activeGameScoreArray.count -1));
                        maxFrameThrowCount = 3;
                        frameThrowCount++;
                    } else {
                        //Advance to next frame
                        overallFrameCounter++;
                        frameThrowCount = 1;
                    }
                    
                    //Change frameStatusLabel to appropriate frame
                    _frameStatusLabel.text = [NSString stringWithFormat:@"Frame %d", (overallFrameCounter+1)];
                    
                } else {
                    frameThrowCount++;
                }
                
                NSLog(@"Adding +1 to existing FrameThrowCount : %d", frameThrowCount);
                NSLog(@"Overall Frame Throw Count = %d", frameThrowCount);
                NSLog(@"Overall Max Frame Throw Count = %d", maxFrameThrowCount);
                
                //Clear throw count label
                _throwCountLabel.text = @"";
                
                NSLog(@"------------------------------------------------");

            }
            
        }
        
        if(overallFrameCounter >= 5) {
            [_scoreCardScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
        }
        
        
        
    }

}
@end
