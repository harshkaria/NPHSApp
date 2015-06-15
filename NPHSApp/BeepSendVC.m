//
//  BeepSendVC.m
//  NPHSApp
//
//  Created by Harsh Karia on 3/24/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "BeepSendVC.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "RKDropdownAlert.h"

@interface BeepSendVC ()

@property UIBarButtonItem *sendButton;
@property NSString *finalString;
@property NSMutableArray *badWords;
@property NSTimer *timer;
@property NSInteger timeInt;
-(BOOL)containsBadWords:(NSString * )string;
@end

@implementation BeepSendVC
@synthesize beepTextView, finalString, badWords, timer, timeInt;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = nil;

    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    
    beepTextView.layer.cornerRadius = 4;
    beepTextView.layer.borderWidth = 1;
    beepTextView.layer.borderColor = [[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] CGColor];
    beepTextView.delegate = self;
    
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Beep" style:UIBarButtonItemStyleDone target:self action:@selector(sendBeep)];
    self.navigationItem.rightBarButtonItem = sendButton;
    
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    beepTextView.text = @"";
}
-(void)sendBeep
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"_Installation" objectId:installation.objectId];
    
    //PFQuery *query = [PFInstallation query];
    beepTextView.text = [NSString stringWithFormat:@"%@", beepTextView.text];
    
    
    NSLog([NSString stringWithFormat:@"%li seconds", (long)timeInt]);
    [object fetchIfNeeded];
    if(![self containsBadWords:[beepTextView.text lowercaseString]] && timeInt == 0 && beepTextView.text.length > 0 && ![beepTextView.text isEqualToString:@"Enter Beep Here"] && [object[@"banned"] boolValue] == false)
    {
        PFObject *object = [PFObject objectWithClassName:@"sentBeeps"];
        object[@"beepText"] = beepTextView.text;
        object[@"person"] = installation.objectId;
        object[@"approved"] = [NSNumber numberWithBool:false];
        
        [object saveInBackgroundWithBlock:^(BOOL success, NSError *error)
        {
            if(success & !error)
            {
            [beepTextView resignFirstResponder];
            [self.view endEditing:YES];
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Beeped" message:@"Your beep was sent." time:3];
                
                PFPush *push = [[PFPush alloc] init];
                PFQuery *query = [PFQuery queryWithClassName:@"_Installation"];
                [query whereKey:@"authorized" equalTo:[NSNumber numberWithBool:YES]];
                [push setQuery:query];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"Approve: %@", beepTextView.text], @"alert",
                                            @"default", @"sound",
                                            nil];
                beepTextView.text = @"Enter Beep Here";
              
                [push setData:dictionary];
                [push sendPushInBackground];
                
            }
            timeInt = 45;
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOut:) userInfo:nil repeats:YES];
            
            
        }];
        
        
    }
    else if(timeInt > 0)
    {
       
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Too Much" message:[NSString stringWithFormat:@"Please wait %li seconds before beeping again", (long)timeInt] time:4];
    }
    else if([beepTextView.text isEqualToString:@"Enter Beep Here"] || !(beepTextView.text.length > 0))
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Enter something" message:@"Please type in a Beep before sending" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
        
    }
    else if([object[@"banned"]boolValue] == true)
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"You're banned!" message:[NSString stringWithFormat:@"To dispute this, take a screenshot now. ID: %@", installation.objectId] backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];

        
    }
    else if([self containsBadWords:[beepTextView.text lowercaseString]])
    {
        NSLog([NSString stringWithFormat:@"%li seconds", (long)timeInt]);
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Bad Words!" message:@"Contains naughty words..." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
    }
   
}
-(void)timeOut:(NSTimer *)countdown
{
    timeInt -= 1;
    if(timeInt <= 0)
    {
        timeInt = 0;
        [countdown invalidate];
    }
}

-(BOOL)containsBadWords:(NSString * )string
{
    
   /* badWords = [[NSMutableArray alloc] init];
    [badWords addObject:@"fuck"];
    [badWords addObject:@"shit"];*/
    //[badWords objectAtIndex:<#(NSUInteger)#>]
    // DO arrays
    if(([string containsString:@"fuck"] || [string containsString:@"shit"] || [string containsString:@"bitch"] || [string containsString:@"cunt"] || [string containsString:@"dick"] || [string containsString:@"tit"] || [string containsString:@"puss"] || [string containsString:@"nig"] || [string containsString:@"porn"] || [string containsString:@"8="] || [string containsString:@"8-"] || [string containsString:@"(.)(.)"]))
    {
        return YES;
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
