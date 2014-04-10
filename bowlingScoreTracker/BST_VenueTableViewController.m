//
//  BST_VenueTableViewController.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/9/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_VenueTableViewController.h"
#import "BST_GameViewController.h"

@interface BST_VenueTableViewController ()

@end

@implementation BST_VenueTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set View Title
    self.navigationItem.title = @"Bowling Centers";
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self.revealViewController action:@selector( revealToggle: )];
    

    
    //CLLocation Manager instance
    deviceLocationManager = [[CLLocationManager alloc] init];
    
    //Prepare to get current location
    deviceLocationManager.delegate = self;
    deviceLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [deviceLocationManager startUpdatingLocation];
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        //Provide device lat & long
        NSLog(@"%@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"%@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        
        //Stop updating location once we have initial set up lat & long.
        [deviceLocationManager stopUpdatingLocation];
        
        //Google Places API String w/ hardcoded loc & lat

        gPlacesString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=10000&types=bowling_alley&sensor=false&key=AIzaSyA4LJzJqag2ooErExZmF3v0Z-DydewiC9k", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
        NSLog(@"%@", gPlacesString);
        
        methodURL = [[NSURL alloc] initWithString:gPlacesString];
        methodRequest = [[NSURLRequest alloc] initWithURL:methodURL];
        
        if(methodRequest != nil) {
            gPlacesConnection = [[NSURLConnection alloc] initWithRequest:methodRequest delegate:self];
            gPlacesData = [NSMutableData data];
        }
    }
}

#pragma mark - Connection Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@" ");
    NSLog(@"#########################################");
    NSLog(@"Response Received");
}

//Built in function for passed in data from url
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //Check that there is valid data
    if (data != nil) {
        [gPlacesData appendData:data];
    }
}

//Built in function to check if all data from the request has loaded and save to .xml in app directory
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"ConnectionDidFinishLoading for =  Google Places");
    
    //jsonify nsmutable data defined
    NSError * error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:gPlacesData options:kNilOptions error:&error];
    
    //Pull the results from the response and store within client side array
    venueArray = [json objectForKey:@"results"];
    NSLog(@"%@", [NSString stringWithFormat:@"%lu bowling centers returned", [venueArray count]]);
    
    
    //Loop through the results and grab required data points
    int i;
    for(i=0; i<[venueArray count]; i++) {
        NSLog(@"------------------------------------------------------");
        NSLog(@"%@",[[venueArray objectAtIndex:i]valueForKey:@"name"]);
        
        //NSString * tempName         = [[venueArray objectAtIndex:i]valueForKey:@"name"];
        NSString * tempLocation     = [[venueArray objectAtIndex:i]valueForKey:@"vicinity"];
        
        //Split Vicinity String to grab the city name and concatenate w/ state
        NSArray * tempLocationArray = [tempLocation componentsSeparatedByString:@", "];
        NSString * cityString       = [NSString stringWithFormat:@"%@", [tempLocationArray objectAtIndex:1]];
        NSLog(@"%@", cityString);
    }
    
    [[self tableView] reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return venueArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"venueCell"];
    
    NSString * bowlingCenterName        = [[venueArray objectAtIndex:indexPath.row]valueForKey:@"name"];
    NSString * bowlingCenterLocation    = [[venueArray objectAtIndex:indexPath.row]valueForKey:@"vicinity"];
    
    //Split Vicinity String to grab the city name and concatenate w/ state
    NSArray * tempLocationArray             = [bowlingCenterLocation componentsSeparatedByString:@", "];
    NSString * bowlingCenterLocationString  = [NSString stringWithFormat:@"%@", [tempLocationArray objectAtIndex:1]];
    
    // Configure the cell...
    cell.textLabel.text = bowlingCenterName;
    cell.detailTextLabel.text = bowlingCenterLocationString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@", [NSString stringWithFormat:@"You Selected Index Path: %ld", (long)indexPath.row]);
    
    NSString * bowlingCenterName        = [[venueArray objectAtIndex:indexPath.row]valueForKey:@"name"];
    NSString * bowlingCenterLocation    = [[venueArray objectAtIndex:indexPath.row]valueForKey:@"vicinity"];
    
    //Split Vicinity String to grab the city name and concatenate w/ state
    NSArray * tempLocationArray             = [bowlingCenterLocation componentsSeparatedByString:@", "];
    NSString * bowlingCenterLocationString  = [NSString stringWithFormat:@"%@", [tempLocationArray objectAtIndex:1]];
    
    [_currentSession setObject:bowlingCenterName forKey:@"venueName"];
    [_currentSession setObject:bowlingCenterLocationString forKey:@"city"];
    
    [_currentSession saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"New session should be saved to parse with bowling venue!");
            [self performSegueWithIdentifier:@"gameScoring" sender:nil];
        } else {
            UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Session created error"
                                                                   message:[error.userInfo objectForKey:@"error"]
                                                                  delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil];
            [newAlertView show];
        }
    }];


}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gameScoring"]) {
        
        BST_GameViewController *destinationViewController = segue.destinationViewController;
        
        if(destinationViewController != nil) {
            
            //Pass Object to step 2: select bowling center
            destinationViewController.currentSession = _currentSession;
            
        }
        
    }

}

@end
