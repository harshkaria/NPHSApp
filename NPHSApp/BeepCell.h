//
//  BeepCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 3/9/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeepCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITextView *beepText;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;
@property NSString *myObject;

@end
