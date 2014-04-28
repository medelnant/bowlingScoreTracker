//
//  BST_GameScoringViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 3 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_GameScoringViewController.h"


@interface BST_GameScoringViewController () {

    //Define throw Counter
    int overallGameCount;
    
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
    
    //Define PinPadEntry Pin Count
    int pinPadEntryPinCount;
    
    //Define tenthFrameCount
    bool tenthFrame;
    
    //Define bool for is usingPinPadEntry
    bool isUsingPinPadEntry;
    
    NSMutableArray * pinPadEntryPinsKnockedDown;
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
    
    //Styling
    [_frameStatusLabel setBackgroundColor:[UIColor colorWithRed:0.24 green:0.23 blue:0.33 alpha:1]];
    [_frameStatusLabel setTextColor:[UIColor whiteColor]];
    
    //SegmentedControl Styling
    _scoringEntrySegmentedControl.tintColor = [UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1];
    [_scoringEntrySegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.49 green:0.52 blue:0.72 alpha:1]}forState:UIControlStateNormal];
    [_scoringEntrySegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}forState:UIControlStateSelected];
    
    //Set overallgamecount to zero to initialize
    overallGameCount = 0;
    
    //Add gesture for swiping within navBar to trigger drawer slide open/close
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    //Set View Title
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Game %d", [_currentSession valueForKey:@"title"], overallGameCount];
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationMenuIcon.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector( revealToggle: )];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(debugGame)];
    
     _scoreCardView = [[BST_GameScoreCardNib alloc] initWithFrame:CGRectMake(0, 0, 670, 90)];
    
    //Needed to due mystery insets applied when using with storyBoard and navigationController. (Annoying)
    self.automaticallyAdjustsScrollViewInsets = NO;

    //Set Scroll View Size to nib view dimensions
    [_scoreCardScrollView setContentSize:CGSizeMake(_scoreCardView.frame.size.width, _scoreCardScrollView.frame.size.height)];
    //Add View to scroll view
    [_scoreCardScrollView addSubview: _scoreCardView];
    
    

    
    _userEntryKeyPad = [[BST_KeyPadEntryNib alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    _userEntryKeyPad.delegate = self;
    //Add View to scoringEntry view
    [_scorePadEntryView addSubview: _userEntryKeyPad];
    
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
    
    } else if ([buttonTitle isEqualToString:@"Clear"]) {
        
        //Clear countLabel
        _throwCountLabel.text = @"";
        
        //if tenth frame
        if(overallFrameCounter == 9) {
            
            //Clear throw values from object
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw1"];
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw2"];
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw3"];
        
        } else {
        
            //Clear throw values from object
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw1"];
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw2"];
            
        }
        
        //Reset frame throw count back to 1
        frameThrowCount = 1;
        
        //Update scorecard to reflect the clear action
        [self updateScoreCard];
        
    } else if ([buttonTitle isEqualToString:@"Split"]) {
        NSLog(@"OverallFrameCounter = %d", overallFrameCounter);
        
        if(![[_activeGameScoreArray[overallFrameCounter] valueForKey:@"isSplit"] isEqualToString:@"true"]) {
            [_activeGameScoreArray[overallFrameCounter] setValue:@"true" forKey:@"isSplit"];
            [_userEntryKeyPad.splitButton setTintColor:[UIColor redColor]];
        } else {
            [_activeGameScoreArray[overallFrameCounter] setValue:@"false" forKey:@"isSplit"];
            [_userEntryKeyPad.splitButton setTintColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
        }

    } else {
        _throwCountLabel.text = buttonTitle;
    }
    
}

#pragma mark - PinPadEntry Delegate Methods

- (void)pinPadPressed:(NSInteger)buttonTagIndex forButtonTitle:(NSString*)buttonTitle {
    
    if([buttonTitle isEqualToString:@"Foul"]) {
        
        _throwCountLabel.text = buttonTitle;
        
        
    } else if ([buttonTitle isEqualToString:@"Clear"]) {
        
        //Clear countLabel
        _throwCountLabel.text = @"";
        
        
        //if tenth frame
        if(overallFrameCounter == 9) {
            
            //Clear throw values from object
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw1"];
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw2"];
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw3"];
            
        } else {
            
            //Clear throw values from object
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw1"];
            [_activeGameScoreArray[overallFrameCounter] setValue:@"" forKey:@"throw2"];
            
        }
        
        //Reset pin rack
        for (NSInteger i = 0; i < _userEntryPinPad.pins.count; i++) {
            [_userEntryPinPad.pins[i] setSelected:NO];
        }
        
        //Re-Enable pins from previous throw and removePins from pinPadEntryPinKnockedDown
        for (NSInteger i = 0; i < _userEntryPinPad.pins.count ; i++) {
            [_userEntryPinPad.pins[i] setUserInteractionEnabled:YES];
            [_userEntryPinPad.pins[i] setAlpha:1];
            [pinPadEntryPinsKnockedDown removeAllObjects];
        }
        
        //Reset pinPadEntryPinCount
        pinPadEntryPinCount = 0;
        
        //Reset frame throw count back to 1
        frameThrowCount = 1;
        
        //Update scorecard to reflect the clear action
        [self updateScoreCard];
        
    } else if ([buttonTitle isEqualToString:@"Split"]) {
        
        if(![[_activeGameScoreArray[overallFrameCounter] valueForKey:@"isSplit"] isEqualToString:@"true"]) {
            [_activeGameScoreArray[overallFrameCounter] setValue:@"true" forKey:@"isSplit"];
            [_userEntryPinPad.splitButton setTintColor:[UIColor redColor]];
        } else {
            [_activeGameScoreArray[overallFrameCounter] setValue:@"false" forKey:@"isSplit"];
            [_userEntryPinPad.splitButton setTintColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
        }
        
    }  else if([buttonTitle isEqualToString:@"X"] || [buttonTitle isEqualToString:@"/"]) {
       
        _throwCountLabel.text = buttonTitle;
        
    } else {
        
        if(![_userEntryPinPad.pins[buttonTagIndex] isSelected]) {
            
            //Store pin in array to disable for second throw state
            [pinPadEntryPinsKnockedDown addObject:_userEntryPinPad.pins[buttonTagIndex]];
            pinPadEntryPinCount++;
        } else {
            
            //remove pin in array to disable for second throw state
            [pinPadEntryPinsKnockedDown removeObject:_userEntryPinPad.pins[buttonTagIndex]];
            pinPadEntryPinCount--;
        }
        
        _throwCountLabel.text = [NSString stringWithFormat:@"%d", pinPadEntryPinCount];
    }
}

#pragma mark - Custom Methods

- (void)debugGame {
    
    //Frame 1
    [_activeGameScoreArray[0] setValue:@"9" forKey:@"throw1"];
    [_activeGameScoreArray[0] setValue:@"1" forKey:@"throw2"];
    [_activeGameScoreArray[0] setValue:@"true" forKey:@"isSpare"];

    //Frame 2
    [_activeGameScoreArray[1] setValue:@"10" forKey:@"throw1"];
    [_activeGameScoreArray[1] setValue:@"" forKey:@"throw2"];
    [_activeGameScoreArray[1] setValue:@"true" forKey:@"isStrike"];

    //Frame 3
    [_activeGameScoreArray[2] setValue:@"9" forKey:@"throw1"];
    [_activeGameScoreArray[2] setValue:@"1" forKey:@"throw2"];
    [_activeGameScoreArray[2] setValue:@"true" forKey:@"isSpare"];
    
    //Frame 4
    [_activeGameScoreArray[3] setValue:@"10" forKey:@"throw1"];
    [_activeGameScoreArray[3] setValue:@"" forKey:@"throw2"];
    [_activeGameScoreArray[3] setValue:@"true" forKey:@"isStrike"];

    //Frame 5
    [_activeGameScoreArray[4] setValue:@"9" forKey:@"throw1"];
    [_activeGameScoreArray[4] setValue:@"1" forKey:@"throw2"];
    [_activeGameScoreArray[4] setValue:@"true" forKey:@"isSpare"];

    //Frame 6
    [_activeGameScoreArray[5] setValue:@"10" forKey:@"throw1"];
    [_activeGameScoreArray[5] setValue:@"" forKey:@"throw2"];
    [_activeGameScoreArray[5] setValue:@"true" forKey:@"isStrike"];

    //Frame 7
    [_activeGameScoreArray[6] setValue:@"9" forKey:@"throw1"];
    [_activeGameScoreArray[6] setValue:@"1" forKey:@"throw2"];
    [_activeGameScoreArray[6] setValue:@"true" forKey:@"isSpare"];

    //Frame 8
    [_activeGameScoreArray[7] setValue:@"10" forKey:@"throw1"];
    [_activeGameScoreArray[7] setValue:@"" forKey:@"throw2"];
    [_activeGameScoreArray[7] setValue:@"true" forKey:@"isStrike"];
    
    //Frame 9
    [_activeGameScoreArray[8] setValue:@"9" forKey:@"throw1"];
    [_activeGameScoreArray[8] setValue:@"1" forKey:@"throw2"];
    [_activeGameScoreArray[8] setValue:@"true" forKey:@"isSpare"];
    
    overallFrameCounter = 9;
    
    [self calculateFrameScore];

    //Frame 10
    //[_activeGameScoreArray[9] setValue:@"X" forKey:@"throw1"];
    //[_activeGameScoreArray[9] setValue:@"9" forKey:@"throw2"];
    //[_activeGameScoreArray[9] setValue:@"1" forKey:@"throw3"];
    
}

- (void)createNewGame {
    [self createEmptyGameArray];
    [self clearGameScoreCard];
    
    overallGameCount++;
    
    //Set View Title
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Game %d", [_currentSession valueForKey:@"title"], overallGameCount];
    
    //Set overallFrameCounter
    overallFrameCounter = 0;
    
    //Set frameThrowCount & maxFrameThrowCount
    frameThrowCount = 1;
    maxFrameThrowCount = 2;
    
    _activeGameScoreArray = [self createEmptyGameArray];
    
    _frameStatusLabel.text  = @"Frame 1";
    _throwCountLabel.text   = @"";
    
    //Reset strike/spare button to strike in case spare was present for last frame in previous games tenth frame
    [_userEntryKeyPad.strikeSpareButton setTitle:@"X" forState:UIControlStateNormal];
    [_userEntryPinPad.strikeSpareButton setTitle:@"X" forState:UIControlStateNormal];
    
    [self updateScoreCard];
    
}

- (void)calculateFrameScore {
    
    int tempGameTotal = 0;

    for (NSInteger i = 0; i < _activeGameScoreArray.count; i++) {
        
        int tempFrameTotal = 0;
        int tempThrow1 = [[_activeGameScoreArray[i] valueForKey:@"throw1"] intValue];
        int tempThrow2 = [[_activeGameScoreArray[i] valueForKey:@"throw2"] intValue];
        int tempCombinedThrow = tempThrow1 + tempThrow2;
        
        if(i < (_activeGameScoreArray.count-1)) {
            
            //If frame is strike
            if([[_activeGameScoreArray[i] valueForKey:@"isStrike"] isEqualToString:@"true"]) {
                
                //Handle converting "X" to pin count
                tempThrow1 = 10;
                
                //Frame total is equal to first throw of 10
                tempFrameTotal += tempThrow1;
                
                //If next frame is strike
                if([[_activeGameScoreArray[i+1] valueForKey:@"isStrike"] isEqualToString:@"true"]) {
                    
                    //Keep adding to frame total
                    tempFrameTotal += 10;
                    //NSLog(@"There is a strike in the next frame. I'm psychic. And my pin total is now:  %d", tempFrameTotal);
                    
                    //If two frames away is strike
                    if(i < (_activeGameScoreArray.count-2)) {
                        
                        if([[_activeGameScoreArray[i+2] valueForKey:@"isStrike"] isEqualToString:@"true"]) {
                            
                            //Keep adding to frame total
                            tempFrameTotal += 10;
                            //NSLog(@"There is a strike two frames away. I'm psychic. And my pin total is now:  %d", tempFrameTotal);
                            
                        } else {
                            //Retrieve next frame first throw
                            int tempTwoThrowsAway = [[_activeGameScoreArray[i+2] valueForKey:@"throw1"] intValue];
                            
                            //Frame total is equal to 10 + nextThrow
                            tempFrameTotal += tempTwoThrowsAway;
                            //NSLog(@"This frame is a spare. And my pin total is now:  %d", tempFrameTotal);
                        }
                    }
                    
                } else if([[_activeGameScoreArray[i+1] valueForKey:@"isSpare"] isEqualToString:@"true"]){
                    tempFrameTotal += 10;
                }
            
            //If frame is spare
            } else if ([[_activeGameScoreArray[i] valueForKey:@"isSpare"] isEqualToString:@"true"]) {
                
                //Retrieve next frame first throw
                int tempNextThrow = [[_activeGameScoreArray[i+1] valueForKey:@"throw1"] intValue];
                
                //If next throw is equal to strike override "X" with pin count
                if([[_activeGameScoreArray[i+1] valueForKey:@"throw1"] isEqualToString:@"10"]) {
                    tempNextThrow = 10;
                }
                
                //Frame total is equal to 10 + nextThrow
                tempFrameTotal += (10 + tempNextThrow);
                //NSLog(@"This frame is a spare. And my pin total is now:  %d", tempFrameTotal);
                
            //If frame is normal (no strike nor spare)
            } else {
                
                //Frame total is equal to the combined total of throw 1 and throw 2
                tempFrameTotal += tempCombinedThrow;
                //NSLog(@"This frame is a regular frame. And my pin total is now:  %d", tempFrameTotal);
            }
            
            //If ninth frame (index 8)
            if(i == 8) {
                //Determine if 10th frame spare happens
                int tenthFrameThrow1 = [[_activeGameScoreArray[i+1] valueForKey:@"throw1"] intValue];
                int tenthFrameThrow2 = [[_activeGameScoreArray[i+1] valueForKey:@"throw2"] intValue];
                int tenthFrameFirstTwoThrows = tenthFrameThrow1 + tenthFrameThrow2;
                
                if([[_activeGameScoreArray[i] valueForKey:@"isStrike"] isEqualToString:@"true"]) {
                    
                    //If throw is a strike (10th frame)
                    if(tenthFrameThrow1 == 10) {
                        
                        //Keep adding to frame total
                        tempFrameTotal += 10;
                        
                        //NSLog(@"There is a strike in the next frame. I'm psychic. And my pin total is now:  %d", tempFrameTotal);
                        if(tenthFrameThrow2 == 10) {
                            
                            //Keep adding to frame total
                            tempFrameTotal += 10;
                            //NSLog(@"There is a strike two frames away. I'm psychic. And my pin total is now:  %d", tempFrameTotal);
                        }
                        
                        //If frame is spare
                    } else if(tenthFrameFirstTwoThrows == 10){
                        
                        tempFrameTotal += 10;
                    }
                }
            }
            
        } else {
            int tenthFrameThrow1 = [[_activeGameScoreArray[i] valueForKey:@"throw1"] intValue];
            int tenthFrameThrow2 = [[_activeGameScoreArray[i] valueForKey:@"throw2"] intValue];
            int tenthFrameThrow3 = [[_activeGameScoreArray[i] valueForKey:@"throw3"] intValue];
            
            tempFrameTotal = tenthFrameThrow1 + tenthFrameThrow2 + tenthFrameThrow3;
            
            //If second throw in tenth frame is populated but not a strike, toggle the strike/spare button to spare.
            if(tenthFrameThrow2 >= 1 && tenthFrameThrow2 != 10 && tempFrameTotal != 10) {
                [_userEntryKeyPad.strikeSpareButton setTitle:@"/" forState:UIControlStateNormal];
                [_userEntryPinPad.strikeSpareButton setTitle:@"/" forState:UIControlStateNormal];
            }
            
            //Hack fix!!! - Issue with tenth frame handling that needs to be fixed after checking values for throws 1 & 2
            //Todo: Revise this or move to nextThrow method and fix the real issue
            if(tempFrameTotal >= 10) {
                maxFrameThrowCount = 3;
                //frameThrowCount++;
            }
            
            //If third throw in tenth frame is populated - trigger end sequence
            if(![[_activeGameScoreArray[9] valueForKey:@"throw3"] isEqualToString:@""]) {
                NSLog(@"My Final Game Array Looks Like This: %@", _activeGameScoreArray);
                
                //Call endGameAndSave
                [self endGameAndSave];
            }
            
        }
        
        tempGameTotal += tempFrameTotal;
        
        //Write game total to frame
        [_activeGameScoreArray[i] setValue:[NSString stringWithFormat:@"%d", tempGameTotal] forKey:@"frameTotal"];
        

        
    }
    
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
            int frameCombinedThrow = [frameThrowCount1 intValue] + [frameThrowCount2 intValue];
            int latterFrameCombinedThrow = [frameThrowCount2 intValue] + [frameThrowCount3 intValue];
            
            //Decode spare scenario to show appopriate label for second throw
            if([frameThrowCount1 intValue] != 10 && frameCombinedThrow == 10) {
                frameThrowCount2 = @"/"; //Second Frame Handling
            }
            if([frameThrowCount2 intValue] != 10 && latterFrameCombinedThrow == 10) {
                frameThrowCount3 = @"/"; // Third Frame Handling
            }
            
            
            //Decode strike pin count to show appopriate label
            if([frameThrowCount1 isEqualToString:@"10"]) {frameThrowCount1 = @"X";}
            if([frameThrowCount2 isEqualToString:@"10"]) {frameThrowCount2 = @"X";}
            if([frameThrowCount3 isEqualToString:@"10"]) {frameThrowCount3 = @"X";}
            
            [_scoreCardView.frames[i][0] setText:frameThrowCount1];
            [_scoreCardView.frames[i][1] setText:frameThrowCount2];
            [_scoreCardView.frames[i][2] setText:frameThrowCount3];
            [_scoreCardView.frameTotals[i] setText:frameTotalValue];
        
        //Handle anyother frame
        } else {
            NSString * frameThrowCount1 = [_activeGameScoreArray[i] valueForKey:@"throw1"];
            NSString * frameThrowCount2 = [_activeGameScoreArray[i] valueForKey:@"throw2"];
            int frameCombinedThrow = [frameThrowCount1 intValue] + [frameThrowCount2 intValue];
            
            //Decode spare scenario to show appopriate label for second throw
            if([frameThrowCount1 intValue] != 10 && frameCombinedThrow == 10) {frameThrowCount2 = @"/";}
            
            //Decode strike pin count to show appopriate label
            if([frameThrowCount1 isEqualToString:@"10"]) {
                frameThrowCount1 = @"X";
                frameThrowCount2 = @"";
            }
            
            //Decode Foul
            if ([frameThrowCount1 isEqualToString:@"F"]) {[_scoreCardView.frames[i][0] setTextColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]];}
            if ([frameThrowCount2 isEqualToString:@"F"]) {[_scoreCardView.frames[i][1] setTextColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]];}
            
            
            //Handle split highlighting
            if([[_activeGameScoreArray[i] valueForKey:@"isSplit"] isEqualToString:@"true"]) {[_scoreCardView.frames[i][0] setTextColor:[UIColor colorWithRed:0.49 green:0.51 blue:0.76 alpha:1]];}
            
            [_scoreCardView.frames[i][0] setText:frameThrowCount1];
            [_scoreCardView.frames[i][1] setText:frameThrowCount2];
            [_scoreCardView.frameTotals[i] setText:frameTotalValue];
        }
    }
    
}

- (void)clearGameScoreCard {
    
    int i;
    
    //Clear throws
    for (i=0; i <= 9; i++) {
        [_scoreCardView.frames[i][0] setText:@""];
        [_scoreCardView.frames[i][0] setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.38 alpha:1]];
        [_scoreCardView.frames[i][1] setText:@""];
        [_scoreCardView.frames[i][1] setTextColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.38 alpha:1]];
    };
    
    //Clear frame totals
    for (i=0; i <= 9; i++) {
        [_scoreCardView.frameTotals[i] setText:@""];
    };
    
    for(i=0; i < [_scoreCardView.frameLabels count]; i++) {
        [_scoreCardView.frameLabels[i] setBackgroundColor:[UIColor colorWithRed:0.24 green:0.23 blue:0.33 alpha:1]];
    }
    
    //Set first frame to be highlighted
    [_scoreCardView.frameLabels[0] setBackgroundColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]];
    [_scoreCardScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void)endGameAndSave {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Complete"
                                                        message:@"Would you like to start a new game? If you choose no, session will end and your game will be saved."
                                                       delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView show];


}

- (void)addThrowCountToGameObject:(NSString*)throwCount {
    
    //Handle Fouls
    if([throwCount isEqualToString:@"Foul"]) {
        throwCount = @"F";
    }
    
    //Decode Strike to pin count and send pin count and advance to next frame
    if([throwCount isEqualToString:@"X"]) {
        
        throwCount = @"10";
        
        //Send correct pin count
        if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
            
            //NSLog(@"Adding tenth frame throws");
            NSString * tenthFrameThrow = [NSString stringWithFormat:@"throw%d", frameThrowCount];
            [_activeGameScoreArray[overallFrameCounter] setObject:throwCount forKey:tenthFrameThrow];
            maxFrameThrowCount = 3;

        } else {
            
            //Anyother frame but the tenth frame
            [_activeGameScoreArray[overallFrameCounter] setObject:throwCount forKey:@"throw1"];
            [_activeGameScoreArray[overallFrameCounter] setObject:@"" forKey:@"throw2"];
            [_activeGameScoreArray[overallFrameCounter] setObject:@"true" forKey:@"isStrike"];
            
        }
    //Else When not a strike
    } else {
        
        //If throw 1 is not empty
        if(![[_activeGameScoreArray[overallFrameCounter] valueForKey:@"throw1"] isEqualToString:@""]) {
            
            //Grab throw 1
            int tempThrow1 = [[_activeGameScoreArray[overallFrameCounter] valueForKey:@"throw1"] intValue];
            int tempThrow2 = [[_activeGameScoreArray[overallFrameCounter] valueForKey:@"throw2"] intValue];
            int tempCombinedThrow;
            int tempCombinedLatterThrow;
            
            tempCombinedThrow = tempThrow1 + [throwCount intValue];
            tempCombinedLatterThrow = tempThrow2 + [throwCount intValue];
            
            if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
                if(tempThrow1 == 10 && tempThrow2 >= 1 && tempThrow2 != 10) {
                    NSLog(@"Is this even catching?");
                    if([throwCount isEqualToString:@"/"]) {
                        throwCount = [NSString stringWithFormat:@"%d", (10-tempThrow2)];
                    }
                } else {
                    //Add both throws together
                    if([throwCount isEqualToString:@"/"]) {
                        throwCount = [NSString stringWithFormat:@"%d", (10-tempThrow1)];
                    }
                }
            }
            
            //Add both throws together
            if([throwCount isEqualToString:@"/"]) {
                throwCount = [NSString stringWithFormat:@"%d", (10-tempThrow1)];
                
                //Set spare flag on frame
                [_activeGameScoreArray[overallFrameCounter] setValue:@"true" forKey:@"isSpare"];
            }
            
            //If total is equal to 10 then we have a spare
            if (tempCombinedThrow == 10) {
                
                if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
                    maxFrameThrowCount = 3;
                } else {
                    
                    //Set spare flag on frame
                    [_activeGameScoreArray[overallFrameCounter] setValue:@"true" forKey:@"isSpare"];
                
                }
            }
        }
        
        [_activeGameScoreArray[overallFrameCounter] setObject:throwCount forKey:[NSString stringWithFormat:@"throw%d", frameThrowCount]];
        
    }
    
    //Special circumstance to run calcScore to total from next throw
    if(overallFrameCounter > 0) {
        if([[_activeGameScoreArray[overallFrameCounter-1] valueForKey:@"isSpare"] isEqualToString:@"true"] && frameThrowCount == 1) {
            [self calculateFrameScore];
        }
    }  
    
    //If strike or throwCount is 2 then process score.
    if([[_activeGameScoreArray[overallFrameCounter] valueForKey:@"isStrike"] isEqualToString:@"true"] || frameThrowCount == 2 || frameThrowCount == 3) {
        
        //Reset Split Button to normal state
        [_activeGameScoreArray[overallFrameCounter] setValue:@"false" forKey:@"isSplit"];
        [_userEntryKeyPad.splitButton setTintColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
        
        [self calculateFrameScore];
        
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
        [frame setValue:@"false" forKey:@"isSplit"];
        [frame setValue:@"" forKey:@"frameTotal"];
        
        //Add third throw for 10th frame
        if(i == 9) {
            [frame setValue:@"" forKey:@"throw3"];
        }
        
        //Add NSMutableDictionary to NSMutableArray
        [gameArray addObject:frame];
    }
    
    //Ship it!
    return gameArray;
}

- (void)nextThrow {
    
    //If throwCountLabel is not empty
    if (![_throwCountLabel.text  isEqual: @""]) {
        
        //If throw is second or third throw
        if(frameThrowCount <= maxFrameThrowCount && frameThrowCount > 1) {
            
            //Disable Split Button
            [_userEntryKeyPad.splitButton setEnabled:YES];
            [_userEntryPinPad.splitButton setEnabled:YES];
            
            
            // If second throw causes frame total to exceed 10 stop and alert
            if ([_throwCountLabel.text intValue] > (10 - firstFramePinCount) && overallFrameCounter < (_activeGameScoreArray.count-1)) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                    message:@"You cannot enter a pin value that will cause frame total to exceed 10"
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            
            //Else proceed with grabbing throw count
            } else {
                
                //FLip button to strike
                [_userEntryKeyPad.strikeSpareButton setTitle:@"X" forState:UIControlStateNormal];
                [_userEntryPinPad.strikeSpareButton setTitle:@"X" forState:UIControlStateNormal];
                
                //Send user throw count to addThrowCountToGameObject
                [self addThrowCountToGameObject:_throwCountLabel.text];
                
                //Clear throw count label
                _throwCountLabel.text = @"";
                
                
                //Reset firstFramePinCount
                firstFramePinCount = 0;
                
                //Reset appropriate frame label to light gray color
                [_scoreCardView.frameLabels[overallFrameCounter] setBackgroundColor:[UIColor colorWithRed:0.24 green:0.23 blue:0.33 alpha:1]];
                
                //If tenth frame
                if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
                    
                    //NSLog(@"Test Advance Click Next: %d out of %lu", overallFrameCounter, (_activeGameScoreArray.count -1));
                    //maxFrameThrowCount = 3;
                    
                    if (frameThrowCount < maxFrameThrowCount) {
                        frameThrowCount++;
                    }
                    
                    //HightLight current frame
                    [_scoreCardView.frameLabels[overallFrameCounter] setBackgroundColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]];
                    
                } else {
                    
                    //Advance to next frame
                    overallFrameCounter++;
                    
                    //Default frameThrowCount to 1
                    frameThrowCount = 1;
                    
                    //HightLight next frame
                    [_scoreCardView.frameLabels[overallFrameCounter] setBackgroundColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]];
                    
                }
                
                //Change frameStatusLabel to appropriate frame
                _frameStatusLabel.text = [NSString stringWithFormat:@"Frame %d", (overallFrameCounter+1)];
                
                if(isUsingPinPadEntry) {
                    //Reset pin rack
                    for (NSInteger i = 0; i < _userEntryPinPad.pins.count; i++) {
                        [_userEntryPinPad.pins[i] setSelected:NO];
                    }
                    
                    //Re-Enable pins from previous throw and removePins from pinPadEntryPinKnockedDown
                    for (NSInteger i = 0; i < _userEntryPinPad.pins.count ; i++) {
                        [_userEntryPinPad.pins[i] setUserInteractionEnabled:YES];
                        [_userEntryPinPad.pins[i] setAlpha:1];
                        [pinPadEntryPinsKnockedDown removeAllObjects];
                    }
                }
            }
        
        //If throw is first throw only
        } else {
            
            //Enable Split Button
            [_userEntryKeyPad.splitButton setEnabled:NO];
            [_userEntryPinPad.splitButton setEnabled:NO];
            
            //Set Frame firstThrowPinCount
            firstFramePinCount = [_throwCountLabel.text intValue];
            
            //Send user throw count to addThrowCountToGameObject
            [self addThrowCountToGameObject:_throwCountLabel.text];
            
            
            //If we're dealing with a strike
            if([_throwCountLabel.text isEqualToString:@"X"] || [_throwCountLabel.text isEqualToString:@"10"] ) {
                
                [_userEntryKeyPad.splitButton setEnabled:YES];
                [_userEntryPinPad.splitButton setEnabled:YES];
                
                if(isUsingPinPadEntry) {
                    //Reset pin rack
                    for (NSInteger i = 0; i < _userEntryPinPad.pins.count; i++) {
                        [_userEntryPinPad.pins[i] setSelected:NO];
                    }
                    
                    //Re-Enable pins from previous throw and removePins from pinPadEntryPinKnockedDown
                    for (NSInteger i = 0; i < _userEntryPinPad.pins.count ; i++) {
                        [_userEntryPinPad.pins[i] setUserInteractionEnabled:YES];
                        [_userEntryPinPad.pins[i] setAlpha:1];
                    }
                    //Remove all pins from knocked down pin grouping
                    [pinPadEntryPinsKnockedDown removeAllObjects];
                }
                
                firstFramePinCount = 10;
                
                //If 10th frame lets not advance frames anymore (or else will crash due to index)
                if(overallFrameCounter == (_activeGameScoreArray.count-1)) {
                    
                    //Reset max throw count to 3
                    //maxFrameThrowCount = 3;
                    
                    //Increment frameThrowCount
                    frameThrowCount++;
                    
                    //Set bool for tenth frame to true
                    tenthFrame = true;
                    
                    NSLog(@"Entering tenth frame!");
                    NSLog(@"FrameThrowCount = %d", frameThrowCount);
                    NSLog(@"MaxFrameThrowCount = %d", maxFrameThrowCount);
                    NSLog(@"My Game Array = %@", _activeGameScoreArray);
                } else {
                    
                    //Advance to next frame
                    overallFrameCounter++;
                    
                    //Reset throwCount to first throw
                    frameThrowCount = 1;
                }
                
                //Change frameStatusLabel to appropriate frame
                _frameStatusLabel.text = [NSString stringWithFormat:@"Frame %d", (overallFrameCounter+1)];

                //Reset appropriate frame label to light gray color
                [_scoreCardView.frameLabels[overallFrameCounter-1] setBackgroundColor:[UIColor colorWithRed:0.24 green:0.23 blue:0.33 alpha:1]];
                
                //HightLight next frame
                [_scoreCardView.frameLabels[overallFrameCounter] setBackgroundColor:[UIColor colorWithRed:0.81 green:0.3 blue:0.36 alpha:1]];
                
            } else {
                
                //FLip button to spare
                [_userEntryKeyPad.strikeSpareButton setTitle:@"/" forState:UIControlStateNormal];
                [_userEntryPinPad.strikeSpareButton setTitle:@"/" forState:UIControlStateNormal];
                
                //Advance to next throw
                frameThrowCount++;
        
            }
            
            //Clear throw count label
            _throwCountLabel.text = @"";
            
        }
        
        //If Using PinPadEntry
        if(isUsingPinPadEntry) {
            
            //Reset PinPadEntryPinCount on every throw
            pinPadEntryPinCount = 0;
            
            //Disable interaction with pins from first throw for second throw
            for (NSInteger i = 0; i < pinPadEntryPinsKnockedDown.count ; i++) {
                [pinPadEntryPinsKnockedDown[i] setUserInteractionEnabled:NO];
                [pinPadEntryPinsKnockedDown[i] setAlpha:0.5];
            }
        }
    }
    
    //Advance scrollView for score card to second half of the card if in frame 5 or greater
    if(overallFrameCounter >= 5) {
        [_scoreCardScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    }
    
    //Advance scrollView for score card to second half of the card if in frame 8 or greater
    if(overallFrameCounter >= 8) {
        [_scoreCardScrollView setContentOffset:CGPointMake(350, 0) animated:YES];
    }

}

- (void) previousThrow {
    
    //If in any frame other than first frame
    if(overallFrameCounter > 0) {
        
        //Decrement frameCounter
        overallFrameCounter--;
        
    }
    
    //Scrollback for score card to first half of the card if in frame 5 or less
    if(overallFrameCounter <= 5) {
        [_scoreCardScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: YES ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeftSideMost animated: YES];
        };
        
    }

}


#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    //Handle saving no matter the selection of the user
    
    NSLog(@"%@", [NSString stringWithFormat:@"Alert Button Index: %ld", (long)buttonIndex]);
    
    //Retrive text from textfield and assign to pointer
    NSString * gameTitle = [NSString stringWithFormat:@"Game %d", overallGameCount];
    NSString * score = [_activeGameScoreArray[9] valueForKey:@"frameTotal"];
    
    //Create new game object
    PFObject * newGame = [PFObject objectWithClassName:@"Game"];
    
    //Set attributes for object
    [newGame setObject:[PFUser currentUser] forKey:@"bowler"];
    [newGame setObject:gameTitle forKey:@"title"];
    [newGame setObject:_activeGameScoreArray forKey:@"gameArray"];
    [newGame setObject:score forKey:@"totalScore"];
    
    // Create relationship
    [newGame setObject:_currentSession forKey:@"session"];
    
    [newGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            
            //Call query method
            //[self findGamesAssociatedWithSession];
            
            NSLog(@"Game has been saved!");
            
            //Define relation for session
            PFRelation* relatedGames = [_currentSession relationForKey:@"games"];
            
            //Add game to relation for session
            [relatedGames addObject:newGame];
            
            //Save session
            [_currentSession saveInBackground];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        };
    }];
    
    

    //If create new game clicked
    if(buttonIndex != 0) {
        [self createNewGame];
    
    //Else send user back to sessions view
    } else {
        [self performSegueWithIdentifier:@"returnToSessions" sender:nil];
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

}


#pragma mark - UISegmentedControl Delegate Methods

- (IBAction)scoringEntryOptionValueChanged:(UISegmentedControl *)sender {
    
    long index = sender.selectedSegmentIndex;
    
    if(index == 0) {
        
        _userEntryKeyPad = [[BST_KeyPadEntryNib alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        _userEntryKeyPad.delegate = self;
        //Add View to scoringEntry view
        [_scorePadEntryView addSubview: _userEntryKeyPad];
        
        //Turn isUsingPinPadEntry off
        isUsingPinPadEntry = NO;
        NSLog(@"_userEntryKeyPad On | _userEntryPinPad Off");
        
    } else {

        _userEntryPinPad = [[BST_PinPadEntryNib alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        _userEntryPinPad.delegate = self;
        //Add View to scoringEntry view
        [_scorePadEntryView addSubview: _userEntryPinPad];
        
        //Turn isUsingPinPadEntry
        isUsingPinPadEntry = YES;
        pinPadEntryPinsKnockedDown = [[NSMutableArray alloc] init];
        NSLog(@"_userEntryKeyPad Off | _userEntryPinPad On");
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
