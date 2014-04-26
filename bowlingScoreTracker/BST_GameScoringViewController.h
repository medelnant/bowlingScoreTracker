//
//  BST_GameScoringViewController.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 3 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/12/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import <Parse/Parse.h>
#import "SWRevealViewController/SWRevealViewController.h"
#import "BST_GameScoreCardNib.h"
#import "BST_KeyPadEntryNib.h"
#import "BST_PinPadEntryNib.h"

@interface BST_GameScoringViewController : UIViewController <KeyPadEntryViewDelegate, PinPadEntryViewDelegate>
{

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

//Define scorecard class class
@property (strong, nonatomic) BST_GameScoreCardNib * scoreCardView;
@property (strong, nonatomic) BST_KeyPadEntryNib * userEntryKeyPad;
@property (strong, nonatomic) BST_PinPadEntryNib * userEntryPinPad;

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

//Setup new game methods
- (void)createNewGame;
- (NSMutableArray*)createEmptyGameArray;

//Beast method (heart & soul)
- (void)calculateFrameScore;

- (void)debugGame;

- (void)nextThrow;
- (void)previousThrow;
- (void)addThrowCountToGameObject:(NSString*)throwCount;
- (void)updateScoreCard;
- (void)clearGameScoreCard;
- (void)endGameAndSave;


//Game Array
@property (strong, nonatomic) NSMutableArray * activeGameScoreArray;

@end
