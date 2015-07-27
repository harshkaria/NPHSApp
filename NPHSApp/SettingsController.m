//
//  SettingsController.m
//  NPHSApp
//
//  Created by Harsh Karia on 7/25/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "SettingsController.h"
#import "SettingsCell.h"
#import <Parse/Parse.h>

@interface SettingsController ()

@property PFInstallation *currentInstallation;
@property NSMutableArray *badWords;
@property NSString *final;

@end

@implementation SettingsController
@synthesize currentInstallation, badWords, final;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [UIView new];
    currentInstallation = [PFInstallation currentInstallation];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    NSString *currentDogTag = [currentInstallation objectForKey:@"dogTag"];
    cell.detailsLabel.text = @"";
    
    // Creates Switch
    
    if(indexPath.row == 0)
    {
        cell.settingsPrompt.text = @"Generate New Dog Tag";
        cell.dogTagButton = [[UIButton alloc] initWithFrame:CGRectMake(266, 15, 48, 30)];
        cell.dogTagButton.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
        [cell.dogTagButton setTitleColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forState:UIControlStateNormal];
        cell.dogTagButton.layer.cornerRadius = 10;
        cell.dogTagButton.layer.borderWidth = 1;
        cell.dogTagButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [cell.dogTagButton setTitle:currentDogTag forState:UIControlStateNormal];
        cell.dogTagButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        [cell.dogTagButton addTarget:self action:@selector(changeDogTag:) forControlEvents:UIControlEventTouchUpInside];
        cell.detailsLabel.text = @"This means old Beeps will no longer be linked to you";
        cell.accessoryView = cell.dogTagButton;
        [cell.contentView addSubview:cell.dogTagButton];
    }
    
    if(indexPath.row == 1)
    {
    
    cell.settingsPrompt.text = @"Display Dog Tag on Topics Page";
    UISwitch *settingsSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    settingsSwitch.tintColor = [UIColor whiteColor];
    settingsSwitch.backgroundColor = [UIColor blackColor];
    [settingsSwitch addTarget:self action:@selector(displayDogTag:) forControlEvents:UIControlEventValueChanged];
    if([[[PFInstallation currentInstallation] objectForKey:@"dtOn"] boolValue] == true)
    {
            [settingsSwitch setThumbTintColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
            [settingsSwitch setOnTintColor:[UIColor blackColor]];
            [settingsSwitch setOn:YES];
    }
    else
    {
        settingsSwitch.thumbTintColor = [UIColor redColor];
    }
    cell.accessoryView = settingsSwitch;
    [cell.contentView addSubview:settingsSwitch];
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)changeDogTag:(id)sender
{
    UIButton *settingsSwitch = (UIButton *)sender;
    SettingsCell *settingsCell = (SettingsCell *)settingsSwitch.superview;
    [settingsCell.dogTagButton setTitle:[self randomizeDogTag] forState:UIControlStateNormal];
    
    
}
-(void)displayDogTag:(id)sender
{
    UISwitch *settingsSwitch = (UISwitch *)sender;
    SettingsCell *settingsCell = (SettingsCell *)settingsSwitch.superview;
    if([settingsSwitch isOn])
    {
        [currentInstallation setObject:[NSNumber numberWithBool:YES] forKey:@"dtOn"];
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"False");
        [currentInstallation setObject:[NSNumber numberWithBool:NO] forKey:@"dtOn"];
        [self.tableView reloadData];
    }
    
}
-(NSString *)randomizeDogTag
{
    BOOL keepGoing = true;
    NSMutableArray *existingTags = [self getTags];
    while (keepGoing) {
        badWords = [[NSMutableArray alloc] initWithObjects:@"ASS", @"AZN",  @"BBW", @"BJS", @"BLK", @"BRA", @"BUD", @"BUM", @"BUN", @"COC", @"COK", @"COX", @"CUM", @"DIK", @"DIX", @"FAG", @"FAP", @"FDB", @"FGT", @"FKU", @"FTB", @"FTP", @"FUK", @"FUQ",  @"GAI", @"GAY", @"GEY", @"GOD", @"GUN", @"HOE", @"JAP", @"JEW", @"JIZ", @"KEV", @"KMS", @"KKK", @"KOK", @"KOX", @"KUM", @"LES",  @"LEZ", @"LIK", @"LSD", @"NGR", @"NIG", @"NIP", @"NUT", @"PEE", @"PIG", @"PISS", @"PMS", @"POO", @"POT", @"PRN", @"PSY",  @"PUS", @"RAK", @"SAK", @"SIP", @"SMA", @"SMD", @"SOB", @"STD", @"SUK", @"SXY", @"THC", @"TIT", @"VAG",  @"VAJ", @"WTF", @"WTH", @"XXX",  nil];
        
        PFInstallation *installation = [PFInstallation currentInstallation];
        NSString *alpha = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        // 0-25
        int a = arc4random() % 26;
        NSString *stringA = [alpha substringWithRange:NSMakeRange(a, 1)];
        int b = arc4random() % 26;
        NSString *stringB = [alpha substringWithRange:NSMakeRange(b, 1)];
        int c = arc4random() % 26;
        NSString *stringC = [alpha substringWithRange:NSMakeRange(c, 1)];
        final = [NSString stringWithFormat:@"%@%@%@", stringA, stringB, stringC];
        if(![badWords containsObject:final] && ![existingTags containsObject:final])
        {
            [self removeTag];
            PFObject *tagObject = [PFObject objectWithClassName:@"Tags"];
            tagObject[@"dogTag"] = final;
            [tagObject saveInBackground];
            [installation setObject:final forKey:@"dogTag"];
            [installation setObject:[NSNumber numberWithBool:NO] forKey:@"authorized"];
            [installation saveInBackground];
            keepGoing = false;
        }
        
    }
    return final;
    
}
-(NSMutableArray *)getTags
{
    PFQuery *usageQuery = [PFQuery queryWithClassName:@"Tags"];
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    
    [usageQuery findObjectsInBackgroundWithBlock:^(NSArray *usageArray, NSError *error)
     {
         for(PFObject *object in usageArray)
         {
             [finalArray addObject:object[@"dogTag"]];
         }
     }];
    return finalArray;
    
}
-(void)removeTag
{
    PFQuery *removeComments = [PFQuery queryWithClassName:@"Comments"];
    [removeComments whereKey:@"dogTag" equalTo:currentInstallation[@"dogTag"]];
    [removeComments findObjectsInBackgroundWithBlock:^(NSArray *commentsQuery, NSError *error)
     {
        for(PFObject *object in commentsQuery)
        {
            object[@"dogTag"] = @"";
            [object saveInBackground];
        }
     }];
    
    PFQuery *removeQuery = [PFQuery queryWithClassName:@"Tags"];
    [removeQuery whereKey:@"dogTag" equalTo:currentInstallation[@"dogTag"]];
    PFObject *removeObject = [removeQuery getFirstObject];
    [removeObject deleteInBackground];
}
                                                
                                    
@end
