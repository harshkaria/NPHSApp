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
#import "AppDelegate.h"
@interface NotificationViewController ()
@property NSString *username;
@end

@implementation NotificationViewController
@synthesize notificationField, sendLabel, username;

- (void)viewDidLoad {
    [super viewDidLoad];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    username = [[PFUser currentUser]username];
    if(currentInstallation.badge != 0)
    {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
    }
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor yellowColor]};
    
    self.navigationItem.title = [NSString stringWithFormat:@"Send: %@", [username uppercaseString]];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];
    
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    PFQuery *query = [PFUser query];
    // Customize Notification Field
    
    notificationField.textColor = [UIColor blackColor];
    
    notificationField.layer.borderWidth = 0;
    notificationField.delegate = self;
    NSNumber *number = [[NSNumber alloc]initWithInteger:[query countObjects]];
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOutAction)];
    self.navigationItem.leftBarButtonItem = logOut;
    [RKDropdownAlert show];
    [RKDropdownAlert title:[NSString stringWithFormat:@"Welcome, %@", [username uppercaseString]] message:@"Go ahead and do your thing" backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:1 green:(251.0/255.0) blue:(38.0/255.0) alpha:1]time:3];
    [sendLabel setTextColor:[UIColor yellowColor]];
        
    
    NSLog(@"%@", number);
    
    sendLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    notificationField.text = @"";
}
- (IBAction)sendButton:(id)sender
{
    if(notificationField.text.length == 0 || [notificationField.text isEqualToString:@"Enter Notification Here:"])
    {
        [RKDropdownAlert show];
         [RKDropdownAlert title:[NSString stringWithFormat:@"Please enter a notification."]  backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:1 green:(251.0/255.0) blue:(38.0/255.0) alpha:1]time:3];
    }
    else
    {
    
    PFPush *push = [[PFPush alloc] init];
   
    NSString *channel = username;
    NSString *notification = [NSString stringWithFormat:@"%@: %@", username, notificationField.text];
    
    
    [push setChannel:channel];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          notification, @"alert",
                          @"Increment", @"badge",
                          nil, nil,
                          
                          nil];
    [push setData:data];
    [push sendPushInBackground];
    }
    
}
-(void)logOutAction
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logOut" sender:self];
    
   
}

@end
