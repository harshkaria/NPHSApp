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
-(BOOL)containsBadWords:(NSString * )string;
@end

@implementation BeepSendVC
@synthesize beepTextView, finalString;

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
    beepTextView.text = [NSString stringWithFormat:@"%@", beepTextView.text];
    
    if(![self containsBadWords:[beepTextView.text lowercaseString]])
    {
        PFObject *object = [PFObject objectWithClassName:@"sentBeeps"];
        object[@"beepText"] = beepTextView.text;
        
        [object saveInBackgroundWithBlock:^(BOOL success, NSError *error)
        {
            if(success & !error)
            {
            beepTextView.text = @"Enter Beep Here";
            [beepTextView resignFirstResponder];
            [self.view endEditing:YES];
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Beeped" message:@"Your beep was sent." time:3];
            }
        }];
    }
    
    else
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Bad Words!" message:@"Contains naughty words..." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
    }
}

-(BOOL)containsBadWords:(NSString * )string
{
    // DO arrays
    if(([string containsString:@"fuck"] || [string containsString:@"shit"] || [string containsString:@"bitch"] || [string containsString:@"cunt"] || [string containsString:@"dick"] || [string containsString:@"tits"] || [string containsString:@"pussy"] || [string containsString:@"nigger"] || [string containsString:@"niggers"] || [string containsString:@"titties"] || [string containsString:@"porn"]))
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
