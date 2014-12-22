//
//  FeedCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 11/23/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *feedView;
@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UITextView *clubText;


@end
