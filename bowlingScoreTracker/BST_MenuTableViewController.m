//
//  BST_MenuTableViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 3 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_MenuTableViewController.h"

@interface BST_MenuTableViewController ()

@end

@implementation BST_MenuTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCell";
    
    //Hook to cell identifiers defined within IB for each proto cell
    //Chose this route to work with static cells w/segues hooked.
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"Sessions";
            break;
            
        case 1:
            CellIdentifier = @"UserSettings";
            break;
            
        case 2:
            CellIdentifier = @"LogOut";
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        
        // Define my segue and main reveal controller
        SWRevealViewControllerSegue* sideDrawerSegue = (SWRevealViewControllerSegue*) segue;
        SWRevealViewController* sideDrawer = self.revealViewController;
        
        //Push to destination view
        sideDrawerSegue.performBlock = ^(SWRevealViewControllerSegue * rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [sideDrawer pushFrontViewController:nc animated:YES];
            
        };
        
    }
    
    // Logout based on segue identifier
    if([[segue identifier] isEqualToString:@"logOut"]) {
        
        [PFUser logOut];
        
    }

}


@end
