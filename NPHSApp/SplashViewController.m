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
#import <Parse/Parse.h>
@interface SplashViewController ()

@end

// BLACK TO YELLOW


@implementation SplashViewController
@synthesize james;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:screenBound];
    shimmeringView.translatesAutoresizingMaskIntoConstraints = NO;
    
   // PFConfig *config = [PFConfig getConfig];
    //PFFile *file = [config objectForKey:@"bg"];
    //NSData *imageData = [file getData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:screenBound];
    imageView.image = [UIImage imageNamed:@"Paw.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    
    NSString *picByLabel = @"";
    
    UILabel  *myText = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width / 2, screenSize.height / 2, 300, 120)];
    myText.text = @"NPHS";
    myText.textAlignment = NSTextAlignmentCenter;
    myText.font = [UIFont fontWithName:@"Dekar Light" size:125];
    myText.textColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    UILabel *picBy = [[UILabel alloc]init];
    
    if(screenSize.height == 480)
    {
        picBy.frame = CGRectMake(screenSize.width * 0.2, screenSize.height * 0.91, 495, 60);
    }
    else if(screenSize.height == 568)
    {
        picBy.frame = CGRectMake(screenSize.width * 0.2, screenSize.height * 0.93, 495, 60);
    }
    else
    {
        picBy.frame = CGRectMake(screenSize.width * 0.24, screenSize.height * 0.94, 495, 60);
    }
    picBy.text = picByLabel;
    picBy.textColor = [UIColor whiteColor];
    picBy.font = [UIFont fontWithName:@"HelveticaNeue-Strong" size:40];
    picBy.alpha = 1;
    
    
    shimmeringView.contentView = myText;
    
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringSpeed = 250;
    shimmeringView.shimmeringOpacity = 0.3;
    
    shimmeringView.shimmeringDirection = FBShimmerDirectionRight;
    shimmeringView.shimmeringAnimationOpacity = 1;
    [self.view addSubview:shimmeringView];
    [shimmeringView addSubview:myText];
    //[shimmeringView addSubview:picBy];
    
    // Start shimmering.
    
    
    
    
    
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
