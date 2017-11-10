//
//  RulesViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 8/9/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "RulesViewController.h"

@interface RulesViewController ()
@property NSMutableArray *rulesArray;
@end

@implementation RulesViewController
@synthesize rulesTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Rules";
    rulesTextView.text = @"1) You MUST be a Newbury Park Panther! \n2) NEVER reveal your name, address, phone number, or other personal information, in order to retain complete anonymity \n3) NEVER state other Panthers' names, or declare any other peoples' personal information in order to protect others' privacy (only refer to others with their Dog Tags, i.e. \"@XYZ\") \n4) NO Beeps may refer to a Newbury Park administrator, or other staff/faculty member in a negative context \n5) Sexual harassment is NOT tolerated (flirt elsewhere!) \n6) Bullying and harassing other Panthers is NEVER tolerated \n7) NO explicit content is allowed in text and images, i.e.  nudity or violence \n8) Do NOT spam/post useless content to clutter the Beep Feed \n9) Express your opinions with courtesy and respect for others' values";
    // Do any additional setup after loading the view.
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
