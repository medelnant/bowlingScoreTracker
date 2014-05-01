//
//  BST_VenueTableViewController.h
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/9/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController/SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface BST_VenueTableViewController : UITableViewController <CLLocationManagerDelegate>
{
    
    //Define API Strings
    NSString * gPlacesString;
    
    //Connection Vars
    NSURLRequest * methodRequest;
    NSURL * methodURL;
    NSURLConnection * gPlacesConnection;
    
    //DataObjects for storing info from url
    NSMutableData * gPlacesData;
    
    //NSMutableArray to populate tableview
    NSMutableArray * venueArray;
    
    //Define Location Manager
    CLLocationManager * deviceLocationManager;

}
//Define PFObject for receving & passing from/to other view controllers
@property PFObject * currentSession;

@end
