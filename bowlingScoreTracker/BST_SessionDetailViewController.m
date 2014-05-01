//
//  BST_SessionDetailViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 4 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/25/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_SessionDetailViewController.h"
#import "BST_SessionGameCardTableViewCell.h"

@interface BST_SessionDetailViewController () {

    int totalThrowCount;
    int strikeCount;
    int nonStrikeCount;
    int spareCount;
    int singlePinLeaves;
    int singlePinSpares;


}


@end

@implementation BST_SessionDetailViewController

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
    //Call gatherReportData at the start (Uses GCD to process on separate thread)
    [self gatherReportData];
    
    //Necessary to fix issues with tableView offset/inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //For some odd reason new to set contentInset for tableview to avoid overlap of navigationController
    self.detailTableView.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 10.0f, 0.0f);
    
    //Styling
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.91 blue:0.94 alpha:1];
    
    //Add gesture for swiping within navBar to trigger drawer slide open/close
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    //Set View Title
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Session", [_detailedSession valueForKey:@"title"]];
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationMenuIcon.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector( revealToggle: )];
    

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_detailedSession[@"games"] count];
}

- (BST_SessionGameCardTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"gameCell";
    
    BST_SessionGameCardTableViewCell *cell = (BST_SessionGameCardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        
        cell = [[BST_SessionGameCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    NSString * gameTitle = [NSString stringWithFormat:@"Game %ld", (long)indexPath.row+1];
    
    NSInteger gameFrameCount = 10;
    
    for (NSInteger i = 0; i < gameFrameCount; i++) {
        
        //Grab frame values
        NSString * throw1 = [_detailedSession[@"games"][indexPath.row][@"gameArray"][i] valueForKey:@"throw1"];
        NSString * throw2 = [_detailedSession[@"games"][indexPath.row][@"gameArray"][i] valueForKey:@"throw2"];
        NSString * throw3 = [_detailedSession[@"games"][indexPath.row][@"gameArray"][i] valueForKey:@"throw3"];
        NSString * isStrike = [_detailedSession[@"games"][indexPath.row][@"gameArray"][i] valueForKey:@"isStrike"];
        NSString * isSpare = [_detailedSession[@"games"][indexPath.row][@"gameArray"][i] valueForKey:@"isSpare"];
        NSString * frameTotal = [_detailedSession[@"games"][indexPath.row][@"gameArray"][i] valueForKey:@"frameTotal"];
        
        //Check if strike or spare for proper character insert into score card
        if([isStrike isEqualToString:@"true"]) {throw1 = @"X";}
        if([isSpare isEqualToString:@"true"]) {throw2 = @"/";}
        
        //If throw is tenth frame account for third throw
        if(i == 9) {
            
            //Calculate combined throws for first half and second half of frame
            int Throw1PlusThrow2 = [throw1 intValue] + [throw2 intValue];
            int Throw2PlusThrow3 = [throw2 intValue] + [throw3 intValue];
            
            //List of conditional to handle proper character insert for tenth frame
            if([throw1 isEqualToString:@"10"]) {throw1 = @"X";}
            if([throw2 isEqualToString:@"10"]) {throw2 = @"X";}
            if([throw3 isEqualToString:@"10"]) {throw3 = @"X";}
            if(Throw1PlusThrow2 == 10) {throw2 = @"/";}
            if(Throw2PlusThrow3 == 10) {throw3 = @"/";}
    
            //Set third throw
            [cell.frames[i][2] setText:throw3];
        }
        
        //Set values
        [cell.frames[i][0] setText:throw1];
        [cell.frames[i][1] setText:throw2];
        [cell.frameTotals[i] setText:frameTotal];
    }
    
    cell.gameTitle.text = gameTitle;
    
    return cell;
}

- (void) gatherReportData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSInteger gameCount = [_detailedSession[@"games"] count];
        
        int totalSeries = 0;
        
        //Loop through games
        for (NSInteger i =0; i < gameCount; i++) {
            
            NSArray * gameArray = _detailedSession[@"games"][i][@"gameArray"];
            
            totalSeries = totalSeries + [[_detailedSession[@"games"][i] valueForKey:@"totalScore"] intValue];
            NSLog(@"My Game Array %@", [_detailedSession[@"games"][i] valueForKey:@"totalScore"]);
            
            
            //Loop through frames
            for (NSInteger j = 0; j < [gameArray count]; j++) {
                
                //Count total Strikes
                if([[gameArray[j] valueForKey:@"isStrike"] isEqualToString:@"true"]) {
                    strikeCount++;
                } else {
                    nonStrikeCount++;
                }
                
                //TenthFrames
                if(j == ([gameArray count] -1)) {
                    
                    int Throw1PlusThrow2 = [[gameArray[j] valueForKeyPath:@"throw1"] intValue] + [[gameArray[j] valueForKeyPath:@"throw2"] intValue];
                    int Throw2PlusThrow3 = [[gameArray[j] valueForKeyPath:@"throw2"] intValue] + [[gameArray[j] valueForKeyPath:@"throw3"] intValue];
                    
                    //Throw 1
                    if([[gameArray[j] valueForKeyPath:@"throw1"] isEqualToString:@"10"]) {
                        strikeCount++;
                    } else {
                        nonStrikeCount++;
                    }
                    
                    //Throw 2
                    if([[gameArray[j] valueForKeyPath:@"throw2"] isEqualToString:@"10"]) {strikeCount++;}
                    
                    //Throw 3
                    if([[gameArray[j] valueForKeyPath:@"throw3"] isEqualToString:@"10"]) {strikeCount++;}
                    
                    //Check for spares in either front half or back half of frame
                    if(Throw1PlusThrow2 == 10) {spareCount++;}
                    if(Throw2PlusThrow3 == 10) {spareCount++;}
                    
                }
                
                //Count total spares
                if([[gameArray[j] valueForKey:@"isSpare"] isEqualToString:@"true"])  {spareCount++;}
                
                //Count single pin leaves
                if([[gameArray[j] valueForKey:@"throw1"] isEqualToString:@"9"])  {singlePinLeaves++;}
                
                //Count single pin spares
                if([[gameArray[j] valueForKey:@"throw1"] isEqualToString:@"9"] && [[gameArray[j] valueForKey:@"isSpare"] isEqualToString:@"true"])  {singlePinSpares++;}
                
            }
            
        }

        
        //Utilize main que because any UI Operations MUST be done on the main que
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _totalAverage.text  = [NSString stringWithFormat:@"%ld", (totalSeries/gameCount)];
            _totalSeries.text = [NSString stringWithFormat:@"%d", totalSeries];
            _summaryStrikeCount.text = [NSString stringWithFormat:@"%d strikes", strikeCount];
            _summarySpareCount.text = [NSString stringWithFormat:@"%d spares out of %d", spareCount, nonStrikeCount];
            _summarySinglePinSpares.text = [NSString stringWithFormat:@"%d single pin spares out of %d", singlePinSpares, singlePinLeaves];

        });
    });
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

@end
