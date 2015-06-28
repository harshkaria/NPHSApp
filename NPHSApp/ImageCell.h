//
//  ImageCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 6/28/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property NSString *imageName;

@end
