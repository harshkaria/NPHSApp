//
//  ThreadsCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 6/15/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ThreadsCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UIView *custom;


@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property  PFObject *currentThread;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;


@end
