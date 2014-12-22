//
//  CreditsCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 12/4/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UITextView *biography;

@end
