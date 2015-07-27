//
//  ProfileCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 7/26/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topicName;
@property (weak, nonatomic) IBOutlet UITextView *commentText;

@end
