//
//  BST_SessionDetailViewController.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/25/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_SessionDetailViewController.h"
#import "BST_SessionGameCardTableViewCell.h"

@interface BST_SessionDetailViewController ()

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
