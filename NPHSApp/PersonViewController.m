//
//  PersonViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/8/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()

@end

@implementation PersonViewController
@synthesize photoImage, name, nameLabel;
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    name = @"";
}
- (void)viewDidLoad {
    nameLabel.text = name;
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"Back";
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"harsh.png"];
    photoImage.layer.cornerRadius = photoImage.frame.size.width / 2;
    photoImage.layer.borderWidth = 4.0f;
    photoImage.layer.borderColor = [UIColor whiteColor].CGColor;
    photoImage.clipsToBounds = YES;
   // self.photoImage.layer.cornerRadius = image.size.width / 2;
    photoImage.image = image;
    [self.view addSubview:photoImage];
    

    
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
