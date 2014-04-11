//
//  BST_GameViewController.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 2 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/10/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController/SWRevealViewController.h"

@interface BST_GameViewController : UITableViewController {

}

//Store returned data from query within NSMutableArray
@property NSMutableArray * clientSideGamesArray;

//Define PFObject for receving & passing from/to other view controllers
@property PFObject * currentSession;

//Define query for fetching games associated with currentSession
@property PFQuery * currentSessionGameQuery;

//Add Session Method
- (void)addGame;

- (void)findGamesAssociatedWithSession;

- (void)deleteGame:(NSInteger)gameIndex;

@end
