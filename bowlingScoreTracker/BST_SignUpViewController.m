//
//  BST_SignUpViewController.m
//  bowlingScoreTracker
//
//  Created by vAesthetic on 4/6/14.
//  Copyright (c) 2014 medelnant. All rights reserved.
//

#import "BST_SignUpViewController.h"

@interface BST_SignUpViewController ()

@end

@implementation BST_SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Add gesture recognizer to dismiss modal keyboard
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    //Clear Fields
    self.username.text  = @"";
    self.email.text     = @"";
    self.firstName.text = @"";
    self.lastName.text  = @"";
    self.password.text  = @"";
    self.handedNess.selectedSegmentIndex = 1;
    
    
    PFUser * fbBowler = [PFUser currentUser];
    if (fbBowler != nil) {
        
        //Hide navigation bar back button
        self.navigationItem.hidesBackButton = YES;
        
        // Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                
                // Set textfield text values
                self.username.text = userData[@"username"];
                self.email.text = userData[@"email"];
                self.firstName.text = userData[@"first_name"];
                self.lastName.text = userData[@"last_name"];
                
                // Set password to diabled since its not needed, set value to null, change textColor
                self.password.enabled = NO;
                self.password.text = @"null";
                self.password.textColor = [UIColor grayColor];
            }
        }];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void) resignOnTap:(id)sender {
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    
    NSLog(@"Sign Up Clicked!");
    
    //Capture text from textfields and store within NSString pointers
    NSString * userNameText             =  [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * emailText                =  [self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * firstNameText            =  [self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * lastNameText             =  [self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * passwordText             =  [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSNumber * handedNessValue          =  [NSNumber numberWithInteger:_handedNess.selectedSegmentIndex];
    NSString * handedNessValueString    =  [NSString stringWithFormat:@"%@", handedNessValue];
    
    //Test if fields are left empty
    if([userNameText length] == 0 || [passwordText length] == 0 || [firstNameText length] == 0 || [lastNameText length] == 0 || [emailText length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username, email address, first name, last name and password!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else /*Do action*/ {
        NSLog(@"Send data to parse");
        
        //Check against existing user through FB Sign up
        PFUser * fbBowler = [PFUser currentUser];
        
        if(fbBowler != nil){
        
            // Grab textField values and assign to userObject
            fbBowler.username          = userNameText;
            fbBowler.email             = emailText;
            fbBowler[@"firstname"]     = firstNameText;
            fbBowler[@"lastname"]      = lastNameText;
            fbBowler[@"handedNess"]    = handedNessValueString;
            
            [fbBowler saveEventually:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    
                    // Clear Fields
                    self.username.text  = @"";
                    self.email.text     = @"";
                    self.firstName.text = @"";
                    self.lastName.text  = @"";
                    self.password.text  = @"";
                    self.handedNess.selectedSegmentIndex = 1;
                    
                    // Send to loggedInView
                    [self performSegueWithIdentifier:@"loggedIn" sender:nil];
                }
            }];

        } else {
            PFUser * saveBowler = [PFUser user];
            
            // Grab textField values and assign to userObject
            saveBowler.username         = userNameText;
            saveBowler.password         = passwordText;
            saveBowler.email            = emailText;
            saveBowler[@"firstname"]    = firstNameText;
            saveBowler[@"lastname"]     = lastNameText;
            saveBowler[@"handedNess"]    = handedNessValueString;
            
            // Save Bowler to parse
            [saveBowler signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                        message:[error.userInfo objectForKey:@"error"]
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    
                    // Clear Fields
                    self.username.text  = @"";
                    self.email.text     = @"";
                    self.firstName.text = @"";
                    self.lastName.text  = @"";
                    self.password.text  = @"";
                    self.handedNess.selectedSegmentIndex = 1;
                    
                    // Send to loggedInView
                    [self performSegueWithIdentifier:@"loggedIn" sender:nil];
                }
            }];
        }
    }
    
}
@end
