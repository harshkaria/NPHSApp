
//
//  SponsorViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 7/27/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "SponsorViewController.h"

@interface SponsorViewController ()

@end

@implementation SponsorViewController
@synthesize sponsoredObject, sponsorLogo, discountText, addressText, phoneNumberText, websiteText, emailText;
-(PFObject *)getObject
{
    PFQuery *query = [PFQuery queryWithClassName:@"Ads"];
    [query whereKey:@"topicID" equalTo:sponsoredObject.objectId];
    PFObject *adObject = [query getFirstObject];
    return adObject;
}
- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    self.navigationItem.title = sponsoredObject[@"topic"];
    
    PFObject *adObject = [self getObject];
    
    discountText.text = adObject[@"text"];
    PFFile *logo = adObject[@"companyLogo"];
    [logo getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
     {
         UIImage *logo = [UIImage imageWithData:data];
         sponsorLogo.image = logo;
     }];
    
    [discountText setContentOffset:CGPointZero];
    discountText.layer.cornerRadius = 4;
    discountText.layer.borderWidth = 2;
    discountText.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    websiteText.text = adObject[@"website"];
    emailText.text = adObject[@"email"];
    addressText.text = adObject[@"address"];
    phoneNumberText.text = adObject[@"phone"];
    
    
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
