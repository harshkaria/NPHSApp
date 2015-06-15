//
//  PersonViewController.h
//  NPHSApp
//
//  Created by Harsh Karia on 6/8/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property NSString *name;


@end
