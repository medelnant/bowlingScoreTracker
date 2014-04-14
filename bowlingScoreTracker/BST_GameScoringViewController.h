//
//  BST_GameScoringViewController.h
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController/SWRevealViewController.h"
#import "BST_GameScoreCardNib.h"
#import "BST_KeyPadEntryNib.h"
#import "BST_PinPadEntryNib.h"

@interface BST_GameScoringViewController : UIViewController <KeyPadEntryViewDelegate, PinPadEntryViewDelegate>
{
    //Define throw Counter
    int overallFrameCounter;
    int frameThrowCount;
    int maxFrameThrowCount;
    int firstFramePinCount;
}

//Store returned data from query within NSMutableArray
@property NSMutableArray * clientSideGamesArray;

//Define PFObject for receving & passing from/to other view controllers
@property PFObject * currentSession;

//Define query for fetching games associated with currentSession
@property PFQuery * currentSessionGameQuery;

//Define placeholder controls for loading xibs
@property (weak, nonatomic) IBOutlet UIScrollView *scoreCardScrollView;
@property (weak, nonatomic) IBOutlet UIView *scorePadEntryView;

//Define pad class
@property (strong, nonatomic) BST_GameScoreCardNib * scoreCardView;

//Define view controls (SegmentedControl, Labels, Buttons)
@property (weak, nonatomic) IBOutlet UISegmentedControl *scoringEntrySegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *frameStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *throwCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousFrameButton;
@property (weak, nonatomic) IBOutlet UIButton *nextFrameButton;

//Define IBActions
- (IBAction)scoringEntryOptionValueChanged:(id)sender;
- (IBAction)gameFrameNavigation:(UIButton *)sender;

//Define Custom Methods
- (NSMutableArray*)createEmptyGameArray;
- (void)calculateGameScore;
- (void)addThrowCountToGameObject:(NSString*)throwCount;
- (void)clearGameScoring;
- (void)updateScoreCard;
- (void)clearGameScoreCard;



//Game Array
@property (strong, nonatomic) NSMutableArray * activeGameScoreArray;

@end
