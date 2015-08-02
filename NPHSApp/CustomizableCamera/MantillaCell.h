//
//  MantillaCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 8/1/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MantillaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property PFObject *cellObject;
@end
