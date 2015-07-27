//
//  SettingsCell.h
//  NPHSApp
//
//  Created by Harsh Karia on 7/25/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *settingsPrompt;

@property UIButton *dogTagButton;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end
