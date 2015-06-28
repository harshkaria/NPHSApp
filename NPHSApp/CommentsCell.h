//
//  CommentsCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 6/18/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
@interface CommentsCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UIView *customView;

@property (weak, nonatomic) IBOutlet UITextView *commentText;
@property (weak, nonatomic) IBOutlet UIImageView *rankView;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property NSString *currentComment;
@property (weak, nonatomic) IBOutlet UIButton *countButtton;
@end


