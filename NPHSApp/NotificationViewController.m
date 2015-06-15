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
@property NSString *kaboom;
@property NSInteger *subscribers;
@property UIBarButtonItem *send;
@property UIBarButtonItem *viewBeeps;
@property NSString *channel;
@property NSString *notification;
@end

@implementation NotificationViewController
@synthesize notificationField, sendLabel, username, subscribers, send, viewBeeps, channel, notification;

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = nil;
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOutAction)];
    self.navigationItem.leftBarButtonItem = logOut;
    [super viewDidLoad];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    username = [[PFUser currentUser]username];
    
    if(currentInstallation.badge != 0)
    {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
    }
    
    if([username isEqualToString:@"appclub"])
    {
        viewBeeps = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"note-write-7.png"] style:UIBarButtonItemStylePlain target:self action:@selector(beepList)];
        self.navigationItem.rightBarButtonItem = viewBeeps;
    }
    
    
    self.navigationItem.title = [NSString stringWithFormat:@"Send: %@", [username uppercaseString]];
    self.view.backgroundColor = [UIColor blackColor];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];
    
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFUser query];
    // Customize Notification Field
    
   // notificationField.textColor = [UIColor yellowColor];
     notificationField.textColor = [UIColor  colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    notificationField.layer.borderWidth = 0;
    notificationField.delegate = self;
    NSNumber *number = [[NSNumber alloc]initWithInteger:[query countObjects]];
    
    [RKDropdownAlert show];
    [RKDropdownAlert title:[NSString stringWithFormat:@"Welcome, %@", [username uppercaseString]] message:@"Go ahead and do your thing" backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]time:3];
    [sendLabel setTextColor:[UIColor yellowColor]];
        
    
    NSLog(@"%@", number);
    
    sendLabel.hidden = YES;
}
-(void)beepList
{
    self.title = @"Send";
    [self performSegueWithIdentifier:@"Beeps" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    notificationField.text = @"";
    send = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    send.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];

    self.navigationItem.rightBarButtonItem = send;
    
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
       [notifcationField resignFirstResponder];
        NSLog(@"OK");
        [self.view endEditing:YES];
        
        return NO;
        
    }
    return YES;
}
-(void)send
{
    if(notificationField.text.length == 0 || [notificationField.text isEqualToString:@"Enter Notification Here:"])
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Oops!" message:@"Please enter something" backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:1 green:(251.0/255.0) blue:(38.0/255.0) alpha:1]time:3];
        
    }
    else
    {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:username];
        PFObject *object = [query getFirstObject];
        NSString *clubName = [object objectForKey:@"clubName"];
        
        
        PFObject *feed = [PFObject objectWithClassName:@"feed"];
        feed[@"clubName"] = username;
        feed[@"feedPost"] = notificationField.text;
        feed[@"Name"] = clubName;
        [feed saveInBackground];
        
        PFPush *push = [[PFPush alloc] init];
        
        
        notification = [NSString stringWithFormat:@"%@: %@", clubName, notificationField.text];
        channel = username;
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              notification, @"alert",
                              @"Increment", @"badge",
                              @"default", @"sound",
                              nil];

        
        [push setChannel:channel];
        [push setData:data];
        [push sendPushInBackgroundWithBlock:^(BOOL succeded, NSError *error)
        {
             if(succeded && !error)
             {
                 notificationField.text = @"Enter Notification Here:";
                 [notifcationField resignFirstResponder];
                 [self.view endEditing:YES];
                 send.title = @"";
             }
             
         }];
       
        [RKDropdownAlert title:@"Done!" message:[NSString stringWithFormat:@"Your notification has been sent, and pushed to the feed."] backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]time:2];
    }
}

-(void)logOutAction
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logOut" sender:self];
    
   
}

@end
