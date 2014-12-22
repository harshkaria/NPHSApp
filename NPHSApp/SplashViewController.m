//
//  SplashViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 11/21/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "SplashViewController.h"
#import "FBShimmeringView.h"
#import "AppDelegate.h"
@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize james;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.view.bounds];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:VIEW_BG];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imageView];
    UILabel  *myText = [[UILabel alloc] init];
    myText.text = @"NPHS";
    myText.textAlignment = NSTextAlignmentCenter;
    myText.font = [UIFont fontWithName:@"Dekar Light" size:125];
    myText.textColor = [UIColor yellowColor];
    NSURL *url = [NSURL URLWithString:@"http://pannaeyebrow.com/test/pic.txt"];
    NSString *string = [NSString stringWithContentsOfURL:url
                                                encoding:NSUTF8StringEncoding error:nil];
    UILabel *picBy = [[UILabel alloc]initWithFrame:CGRectMake(80, 434, 495, 46)];
    picBy.text = string;
    picBy.textColor = [UIColor whiteColor];
    picBy.font = [UIFont fontWithName:@"HelveticaNeueStrong" size:30];
    [self.view addSubview:picBy];
    
    [self.view addSubview:myText];
    shimmeringView.contentView = myText;
   [self.view addSubview:shimmeringView];
    
    // Start shimmering.
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringSpeed = 250;
    shimmeringView.shimmeringOpacity = 0.1;

    shimmeringView.shimmeringDirection = FBShimmerDirectionRight;
    shimmeringView.shimmeringAnimationOpacity = 1;
    


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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
