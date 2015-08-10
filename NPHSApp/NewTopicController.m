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
#import "ImageCellTableViewController.h"


@interface NewTopicController ()

@property NSMutableArray *existingTopics;

@end

@implementation NewTopicController
@synthesize topicField, characterLabel, promptField, promptCount, existingTopics;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"New Topic";
    topicField.delegate = self;
    promptField.delegate = self;
    [characterLabel setText:@""];
    [promptCount setText:@""];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToPicker)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.liveLabel.hidden = YES;
    self.liveSwitch.hidden = YES;
    if([[[PFUser currentUser] username] isEqualToString:@"appclub"] || [[[PFUser currentUser] username] isEqualToString:@"prowler"] || [[[PFUser currentUser] username] isEqualToString:@"athletics"])
    {
        self.liveLabel.hidden = NO;
        self.liveSwitch.hidden = NO;
    }
    
}

-(BOOL)seeIfExists:(NSString *)topicName
{
    PFQuery *query = [PFQuery queryWithClassName:@"Topics"];
    [query whereKey:@"topic" equalTo:topicName];
    NSInteger count = [query countObjects];
    if(count > 0)
    {
        return true;
    }
    return false;
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range  cementString:(NSString *)string
{
    BeepSendVC *beepVC = [[BeepSendVC alloc] init];
    self.characterLabel.textColor = [UIColor whiteColor];
    self.promptCount.textColor = [UIColor whiteColor];
    if([topicField isFirstResponder])
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger amount = (15 - [newString length]);
        self.characterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)amount];
        if([beepVC containsBadWords:[newString lowercaseString]])
        {
            self.characterLabel.textColor = [UIColor redColor];
        }
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
        if([beepVC containsBadWords:[promptString lowercaseString]])
        {
            self.promptCount.textColor = [UIColor redColor];
        }
        
        if(amount2 == -1)
        {
            self.promptCount.text = @"0";
            self.promptCount.textColor = [UIColor redColor];
            return NO;
        }
    }
    return YES;
}

-(void)goToPicker
{
    if([self isOkayToGo])
    {
    [self performSegueWithIdentifier:@"pickImage" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pickImage"])
    {
        ImageCellTableViewController *imageVC = segue.destinationViewController;
        imageVC.topic = topicField.text;
        imageVC.prompt = promptField.text;
        if([self.liveSwitch isOn])
        {
            imageVC.isLive = YES;
        }
    }
}

-(void)createTopic:(NSString *)topic prompt:(NSString *)prompt imageNamed:(NSString *)imageName isLive:(BOOL)isLive
{
    BeepSendVC *beepVC = [[BeepSendVC alloc] init];
    ImageCellTableViewController *imageVC = [[ImageCellTableViewController alloc] init];
    
        topic = [topic stringByReplacingOccurrencesOfString:@" " withString:@""];
        PFInstallation *installation = [PFInstallation currentInstallation];
        PFObject *topicObject = [PFObject objectWithClassName:@"Topics"];
        topicObject[@"creator"] = installation.objectId;
        topicObject[@"topic"] = [NSString stringWithFormat:@"#%@", topic];
        topicObject[@"prompt"] = prompt;
        topicObject[@"commentCount"] = [NSNumber numberWithInt:0];
        topicObject[@"imageName"] = imageName;
        topicObject[@"live"] = [NSNumber numberWithBool:NO];
        topicObject[@"sponsor"] = [NSNumber numberWithBool:NO];
        topicObject[@"approved"] = [NSNumber numberWithBool:NO];
        topicObject[@"sportGame"] = [NSNumber numberWithBool:NO];
        if(isLive)
        {
            topicObject[@"live"] = [NSNumber numberWithBool:YES];
            topicObject[@"sportGame"] = [NSNumber numberWithBool:YES];
        }
        
        [topicObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
         if(succeeded && !error)
         {
             [self performSegueWithIdentifier:@"BackToThreads" sender:imageVC];
             PFPush *push = [[PFPush alloc] init];
             PFQuery *query = [PFQuery queryWithClassName:@"_Installation"];
             [query whereKey:@"authorized" equalTo:[NSNumber numberWithBool:YES]];
             [push setQuery:query];
             NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSString stringWithFormat:@"#%@ needs approval", topic], @"alert",
                                          @"default", @"sound",
                                         nil];
             [push setData:dictionary];
             [push sendPushInBackground];

         }
    }];
}

-(BOOL)isOkayToGo
{
    BeepSendVC *beepVC = [[BeepSendVC alloc] init];
    ImageCellTableViewController *imageVC = [[ImageCellTableViewController alloc] init];
    
    NSString *topic = topicField.text;
    NSString  *prompt = promptField.text;
    if(![beepVC containsBadWords:[topic lowercaseString]] && ![beepVC containsBadWords:[prompt lowercaseString]] && ![self seeIfExists:[NSString stringWithFormat:@"#%@", topic]] && topic.length >= 3 && prompt.length >= 5 && ![topic containsString:@"#"])
    {
        return true;
    }
    else if([beepVC containsBadWords:[topic lowercaseString]] && ![beepVC containsBadWords:[prompt lowercaseString]])
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Bad Words!" message:@"Contains naughty words..." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
        return false;
    }
    else if([self seeIfExists:[NSString stringWithFormat:@"#%@", topic]])
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Topic Exists!" message:@"This Topic already exists." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
        return false;
    }
    else if(topic.length < 3)
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Topic Length" message:@"You need at least 3 characters for a topic." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
        return false;

    }
    else if(prompt.length < 5)
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Prompt Length" message:@"You need at least 5 characters for the prompt." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
        return false;
        
    }
    else if([topic containsString:@"#"])
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Contains Hashtag" message:@"Please remove the \"#\" from your topic. It will be added in automatically when you post." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
        return false;

    }
    return false;

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
