//
//  PersonViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/8/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "PersonViewController.h"
#import <Parse/Parse.h>

@interface PersonViewController ()

@end

@implementation PersonViewController
@synthesize photoImage, name, nameLabel, personObject, bioText;
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    name = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.name;
    self.bioText.text = personObject[@"bio"];
    

    
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
