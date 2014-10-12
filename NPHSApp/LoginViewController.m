//
//  LoginViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 9/28/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "NotificationViewController.h"
#import "RKDropdownAlert.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameField, passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    usernameField.clearButtonMode = YES;
    usernameField.clearsOnBeginEditing = YES;
    passwordField.clearsOnBeginEditing = YES;
    passwordField.clearButtonMode = YES;
    passwordField.secureTextEntry = YES;
    self.navigationItem.hidesBackButton = YES;
    if([PFUser currentUser])
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self performSegueWithIdentifier:@"goLogin" sender:nil];
    }
       
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldDidReturn:(UITextField *)textField
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


- (IBAction)logIn:(id)sender
{
    NSString *usernameText = [usernameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(usernameField.text.length > 0 && passwordField.text.length > 0)
    {
    [PFUser logInWithUsernameInBackground:[usernameText lowercaseString] password:passwordField.text                                    block:^(PFUser *user, NSError *error) {
            if (user)
            {
                
                NSLog(@"You're in");
                [self dismissViewControllerAnimated:YES completion:nil];
                [self performSegueWithIdentifier:@"goLogin" sender:self];
                                            
            }
            else
            {
                //RKDropdownAlert *dropdown = [[RKDropdownAlert alloc] init];
                [RKDropdownAlert show];
                [RKDropdownAlert title:@"Failed" message:@"Try again noob" backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:1 green:(251.0/255.0) blue:(38.0/255.0) alpha:1]time:3];
                
                
              
            }
        }];
    }
}



@end
