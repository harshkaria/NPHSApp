//
//  LiveScoresVC.m
//  NPHSApp
//
//  Created by Harsh Karia on 8/6/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "LiveScoresVC.h"
#import "RKDropdownAlert.h"
@interface LiveScoresVC ()

@end

@implementation LiveScoresVC
@synthesize liveObject, pantherScore, opponentScore;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Update Live Scores";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)updateButton:(id)sender
{
    if([pantherScore.text length] == 0 || [opponentScore.text length] == 0)
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Enter a Score" message:@"Please enter a score"];
    }
    else
    {
        liveObject[@"prompt"] = [NSString stringWithFormat:@"LIVE - Home: %@  Away: %@           ",    pantherScore.text, opponentScore.text];
        [liveObject saveInBackground];
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Score Updated" message:@"The score was updated."];
        
    }
        
}
@end
