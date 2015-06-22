//
//  NewTopicController.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/16/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//
#import "AppDelegate.h"
#import "NewTopicController.h"
#import <Parse/Parse.h>
#import "BeepSendVC.h"
#import "RKDropdownAlert.h"

@interface NewTopicController ()

@end

@implementation NewTopicController
@synthesize topicField, characterLabel, promptField, promptCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"New Topic";
    topicField.delegate = self;
    promptField.delegate = self;
    [characterLabel setText:@""];
    [promptCount setText:@""];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createTopic)];
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [topicField resignFirstResponder];
    //[self.view endEditing:YES];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.characterLabel.textColor = [UIColor whiteColor];
    self.promptCount.textColor = [UIColor whiteColor];
    if([topicField isFirstResponder])
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger amount = (23 - [newString length]);
        self.characterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)amount];
        if(amount == -1)
        {
            self.characterLabel.text = @"0";
            self.characterLabel.textColor = [UIColor redColor];
            return NO;
        }


    }
    
    else if([promptField isFirstResponder])
    {
        NSString *promptString = [promptField.text stringByReplacingCharactersInRange:range withString:string];
    
        NSInteger amount2 = (50 - [promptString length]);
        self.promptCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)amount2];
        
        if(amount2 == -1)
        {
            self.promptCount.text = @"0";
            self.promptCount.textColor = [UIColor redColor];
            return NO;
        }
    }
    return YES;
}

-(void)createTopic
{
    BeepSendVC *beepVC = [[BeepSendVC alloc] init];
    
    if(![beepVC containsBadWords:[topicField.text lowercaseString]] && ![beepVC containsBadWords:[promptField.text lowercaseString]])
    {
        PFInstallation *installation = [PFInstallation currentInstallation];
        
        PFObject *topicObject = [PFObject objectWithClassName:@"Topics"];
        topicObject[@"creator"] = installation.objectId;
        topicObject[@"topic"] = [NSString stringWithFormat:@"#%@", topicField.text];
        topicObject[@"prompt"] = promptField.text;

        
        [topicObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
         if(succeeded && !error)
         {
             [self performSegueWithIdentifier:@"BackToThreads" sender:self];
         }
    }];
    }
    else
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Bad Words!" message:@"Contains naughty words..." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
    }
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
