//
//  NotificationViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 9/27/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "NotificationViewController.h"
#import <Parse/Parse.h>
#import "RKDropdownAlert.h"
#import "LoginViewController.h"
@interface NotificationViewController ()
@property NSString *username;
@end

@implementation NotificationViewController
@synthesize notificationField, sendLabel, username;

- (void)viewDidLoad {
    [super viewDidLoad];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if(currentInstallation.badge != 0)
    {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
    }
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor yellowColor]};
    username = [[PFUser currentUser]username];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    PFQuery *query = [PFUser query];
    notificationField.clearsOnBeginEditing = YES;
    notificationField.delegate = self;
    NSNumber *number = [[NSNumber alloc]initWithInteger:[query countObjects]];
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOutAction)];
    self.navigationItem.leftBarButtonItem = logOut;
    [RKDropdownAlert show];
    [RKDropdownAlert title:[NSString stringWithFormat:@"Welcome, %@", [username uppercaseString]] message:@"Go ahead and do your thing" backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:1 green:(251.0/255.0) blue:(38.0/255.0) alpha:1]time:3];
    
    NSLog(@"%@", number);
    
    if(![username  isEqual: @"asg"])
    {
    [sendLabel setText:[NSString stringWithFormat:@"Sending Notfication To: %@", [[PFUser currentUser]username]]];
    }
    else
    {
        [sendLabel setText:[NSString stringWithFormat:@"Sending Notfication To: Everyone"]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [notificationField resignFirstResponder];
    NSLog(@"ok");
    return YES;
    
    
}


- (IBAction)sendButton:(id)sender
{
    
    PFPush *push = [[PFPush alloc] init];
   
    NSString *channel = [[PFUser currentUser]username];
    NSString *notification = [NSString stringWithFormat:@"%@: %@", channel, notificationField.text];
    
    
    [push setChannel:channel];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          notification, @"alert",
                          @"Increment", @"badge",
                          nil, nil,
                          
                          nil];
    [push setData:data];
    [push sendPushInBackground];
    
}
-(void)logOutAction
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logOut" sender:self];
    
   
}

@end
