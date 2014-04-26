//
//  BST_LoggedInViewController.m
//  bowlingScoreTracker
//
//  ADP 1 | Week 3 | Term 1404
//  Michael Edelnant
//  Instructor: Lyndon Modomo
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_LoggedInViewController.h"

@interface BST_LoggedInViewController ()

@end

@implementation BST_LoggedInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"You are now logged In");
    
    //Add gesture for swiping within navBar to trigger drawer slide open/close
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    //Set View Title
    self.navigationItem.title = @"Logged In";
    
    //Add barButton left to trigger drawer slide open/close
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self.revealViewController action:@selector( revealToggle: )];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)logUserOut:(id)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
