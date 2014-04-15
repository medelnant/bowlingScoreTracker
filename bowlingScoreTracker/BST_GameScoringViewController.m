//
//  BST_GameScoringViewController.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_GameScoringViewController.h"


@interface BST_GameScoringViewController () {

    //Define throw Counter
    int overallFrameCounter;
    
    //Define Frame Throw Count
    int frameThrowCount;
    
    //Define Max Frame Throw Count
    int maxFrameThrowCount;
    
    //Define First Frame Pin Count
    int firstFramePinCount;
    
    //Define strike count
    int strikeCount;
    
    //Define GameTotal
    int gameTotal;
    
    //Define tenthFrameCount
    bool tenthFrame;
}

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
    
    //Create New Game on view load
    [self createNewGame];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KeyPadEntry Delegate Methods

-(void) keyPadPressed:(NSInteger)buttonTagIndex forButtonTitle:(NSString*)buttonTitle {
    
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

#pragma mark - PinPadEntry Delegate Methods

- (void)pinPadPressed:(NSInteger)buttonTagIndex forButtonTitle:(NSString*)buttonTitle {
    
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

- (void)createNewGame {
    [self createEmptyGameArray];
    [self clearGameScoreCard];
    
    //Set overallFrameCounter
    overallFrameCounter = 0;
    
    //Set frameThrowCount & maxFrameThrowCount
    frameThrowCount = 1;
    maxFrameThrowCount = 2;
    
    _activeGameScoreArray = [self createEmptyGameArray];
    
    _frameStatusLabel.text  = @"Frame 1";
    _throwCountLabel.text   = @"";
}

- (void)calculateFrameScore:(int)frameNumber {
    
    int tempGameTotal = 0;
    
    NSLog(@"GameArrayFrameCount = %lu", (unsigned long)_activeGameScoreArray.count);
    NSLog(@"GameArray = %@", _activeGameScoreArray);
    for (NSInteger i = 0; i< _activeGameScoreArray.count; i++) {
        
        int tempFrameTotal = 0;
        int tempThrow1 = [[_activeGameScoreArray[i] valueForKey:@"throw1"] intValue];
        int tempThrow2 = [[_activeGameScoreArray[i] valueForKey:@"throw2"] intValue];
        int tempCombinedThrow = tempThrow1 + tempThrow2;
        
        
        NSLog(@"--------------------------------------------------");
        NSLog(@"Active index is : %ld", (long)i);
        
        if(i < (_activeGameScoreArray.count-1)) {
            
            //If frame is strike
            if([[_activeGameScoreArray[i] valueForKey:@"isStrike"] isEqualToString:@"true"]) {
                
                //Handle converting "X" to pin count
                tempThrow1 = 10;
                
                //Frame total is equal to first throw of 10
                tempFrameTotal = (tempFrameTotal + tempThrow1);
                
                //If next frame is strike
                if([[_activeGameScoreArray[i+1] valueForKey:@"isStrike"] isEqualToString:@"true"]) {
                    
                    //Keep adding to frame total
                    tempFrameTotal = (tempFrameTotal + 10);
                    NSLog(@"There is a strike in the next frame. I'm psychic. And my pin total is now:  %d", tempFrameTotal);
                    
                    //If two frames away is strike
                    if(i < (_activeGameScoreArray.count-2)) {
                        
                        if([[_activeGameScoreArray[i+2] valueForKey:@"isStrike"] isEqualToString:@"true"]) {
                            
                            //Keep adding to frame total
                            tempFrameTotal = (tempFrameTotal + 10);
                            NSLog(@"There is a strike two frames away. I'm psychic. And my pin total is now:  %d", tempFrameTotal);
                            
                        }
                    }
                } else {
                    
                    //Retrieve next frame combined throw total to itself
                    int tempNextCombinedThrow = [[_activeGameScoreArray[i+1] valueForKey:@"throw1"] intValue] + [[_activeGameScoreArray[i+1] valueForKey:@"throw2"] intValue];
                    
                    //Add next frame combined throw total to itself
                    tempFrameTotal = tempFrameTotal + tempNextCombinedThrow;
                    
                }
            
            //If frame is spare
            } else if ([[_activeGameScoreArray[i] valueForKey:@"isSpare"] isEqualToString:@"true"]) {
                
                //Retrieve next frame first throw
                int tempNextThrow = [[_activeGameScoreArray[i+1] valueForKey:@"throw1"] intValue];
                
                //Frame total is equal to 10 + nextThrow
                tempFrameTotal = (tempFrameTotal + 10) + tempNextThrow;
                NSLog(@"This frame is a spare. And my pin total is now:  %d", tempFrameTotal);
                
            
            //If frame is normal (no strike nor spare)
            } else {
                
                //Frame total is equal to the combined total of throw 1 and throw 2
                tempFrameTotal = tempFrameTotal + tempCombinedThrow;
                NSLog(@"This frame is a regular frame. And my pin total is now:  %d", tempFrameTotal);
                
                
            }
        }
        
        tempGameTotal = tempGameTotal + tempFrameTotal;
        
        //Write game total to frame
        [_activeGameScoreArray[i] setValue:[NSString stringWithFormat:@"%d", tempGameTotal] forKey:@"frameTotal"];
        
        NSLog(@"tempGameTotal = %d", tempGameTotal);
        
        NSLog(@"--------------------------------------------------");
        
        /*
        NSLog(@"Frame1Value = %@", [_activeGameScoreArray[i] valueForKey:@"throw1"]);
        NSLog(@"Frame2Value = %@", [_activeGameScoreArray[i] valueForKey:@"throw2"]);
        NSLog(@"isStrike = %@", [_activeGameScoreArray[i] valueForKey:@"isStrike"]);
        NSLog(@"isSpare = %@", [_activeGameScoreArray[i] valueForKey:@"isSpare"]);
        NSLog(@"--------------------------------------------------");
        */
    }
    
    
    
    //NSString * isStrike = [_activeGameScoreArray[frameNumber] valueForKey:@"isStrike"];
    //NSString * isSpare = [_activeGameScoreArray[frameNumber] valueForKey:@"isSpare"];
    /*
    if([isStrike isEqualToString:@"true"]) {

    }
    
    //Update scoreboard based on activeGameScoreArray
    
    */
    [self updateScoreCard];
}


- (void)updateScoreCard {
    
    for (NSInteger i = 0; i < _activeGameScoreArray.count; i++) {
        
        ///Retrieve frame total
        NSString * frameTotalValue = [_activeGameScoreArray[i] valueForKey:@"frameTotal"];
        
        //Handle tenth frame
        if([_scoreCardView.frames[i] count] > 2) {
            
            NSString * frameThrowCount1 = [_activeGameScoreArray[i] valueForKey:@"throw1"];
            NSString * frameThrowCount2 = [_activeGameScoreArray[i] valueForKey:@"throw2"];
            NSString * frameThrowCount3 = [_activeGameScoreArray[i] valueForKey:@"throw3"];
            
            [_scoreCardView.frames[i][0] setText:frameThrowCount1];
            [_scoreCardView.frames[i][1] setText:frameThrowCount2];
            [_scoreCardView.frames[i][2] setText:frameThrowCount3];
        
        //Handle anyother frame
        } else {
            NSString * frameThrowCount1 = [_activeGameScoreArray[i] valueForKey:@"throw1"];
            NSString * frameThrowCount2 = [_activeGameScoreArray[i] valueForKey:@"throw2"];
            
            [_scoreCardView.frames[i][0] setText:frameThrowCount1];
            [_scoreCardView.frames[i][1] setText:frameThrowCount2];
            [_scoreCardView.frameTotals[i] setText:frameTotalValue];
        }
    }
    
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
            
            //NSLog(@"Adding tenth frame throws");
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
    
    
    //Calculate score and updateScoreCard
    if([[_activeGameScoreArray[overallFrameCounter] valueForKey:@"isStrike"] isEqualToString:@"true"] || frameThrowCount == 2) {
        
        int frameIndex = overallFrameCounter;
        [self calculateFrameScore:frameIndex];
        
    } else {
        
        [self updateScoreCard];
   
    }
    
    

}

- (NSMutableArray*)createEmptyGameArray {

    //NSLog(@"CreateEmptyGameArray called!");
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

- (void)nextThrow {
    
    if (![_throwCountLabel.text  isEqual: @""]) {
        if(frameThrowCount == maxFrameThrowCount) {
            
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
                
                //Reset firstFramePinCount
                firstFramePinCount = 0;
                
                //Reset appropriate frame label to light gray color
                [_scoreCardView.frameLabels[overallFrameCounter] setBackgroundColor:[UIColor lightGrayColor]];
                
                
                
                //If tenth frame
                if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
                    //NSLog(@"Test Advance Click Next: %d out of %lu", overallFrameCounter, (_activeGameScoreArray.count -1));
                    maxFrameThrowCount = 3;
                    NSLog(@"Entering tenth frame!");
                    
                    //HightLight current frame
                    [_scoreCardView.frameLabels[overallFrameCounter] setBackgroundColor:[UIColor darkGrayColor]];
                    
                } else {
                    //Advance to next frame
                    overallFrameCounter++;
                    
                    //Default frameThrowCount to 1
                    frameThrowCount = 1;
                    
                    //HightLight next frame
                    [_scoreCardView.frameLabels[overallFrameCounter] setBackgroundColor:[UIColor darkGrayColor]];
                    
                }
                
                //Change frameStatusLabel to appropriate frame
                _frameStatusLabel.text = [NSString stringWithFormat:@"Frame %d", (overallFrameCounter+1)];
                

                
            }
            
        } else {
            
            //Set Frame firstThrowPinCount
            firstFramePinCount = [_throwCountLabel.text intValue];
            
            //Send user throw count to addThrowCountToGameObject
            [self addThrowCountToGameObject:_throwCountLabel.text];
            
            
            //If we're dealing with a strike
            if([_throwCountLabel.text isEqualToString:@"X"]) {
                
                firstFramePinCount = 10;
                
                //If 10th frame lets not advance frames anymore
                if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
                    //NSLog(@"Test Advance Click Next: %d out of %lu", overallFrameCounter, (_activeGameScoreArray.count -1));
                    maxFrameThrowCount = 3;
                    frameThrowCount++;
                    NSLog(@"Entering tenth frame!");
                    tenthFrame = true;
                } else {
                    //Advance to next frame
                    overallFrameCounter++;
                    frameThrowCount = 1;
                }
                
                //Change frameStatusLabel to appropriate frame
                _frameStatusLabel.text = [NSString stringWithFormat:@"Frame %d", (overallFrameCounter+1)];

                
                //Reset appropriate frame label to light gray color
                [_scoreCardView.frameLabels[overallFrameCounter-1] setBackgroundColor:[UIColor lightGrayColor]];
                
                //HightLight next frame
                [_scoreCardView.frameLabels[overallFrameCounter] setBackgroundColor:[UIColor darkGrayColor]];
                
            } else {
                frameThrowCount++;
            }
            
            //Clear throw count label
            _throwCountLabel.text = @"";
            
            
        }
        
    }
    
    if(overallFrameCounter >= 5) {
        [_scoreCardScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    }

}

- (void) previousThrow {
    
    if(overallFrameCounter > 0) {
        overallFrameCounter--;
    }
    
    if(overallFrameCounter <= 5) {
        [_scoreCardScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
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
    
    if(sender.tag == 0) {
        
        [self previousThrow];
        
    } else {
        
        [self nextThrow];
    }

}
@end
