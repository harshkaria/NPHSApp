//
//  ImageCellTableViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/28/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageCellTableViewController.h"
#import "ImageCell.h"
#import "NewTopicController.h"
#import "RKDropdownAlert.h"
#import <Parse/Parse.h>
#import "ThreadsFeedController.h"
@interface ImageCellTableViewController ()

@property NSMutableArray *images;
@property NSString *imageName;
@property BOOL selectedImageBool;
@end

@implementation ImageCellTableViewController
@synthesize topic, prompt, images, imageName, isLive, selectedImageBool;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Pick an Image";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(selectedImage)];
    self.navigationItem.rightBarButtonItem = addButton;
    //images = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:@"Backgrounds" error:nil];
    images = [NSMutableArray array];
    [[[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSString *path = [obj lastPathComponent];
        if ([path hasPrefix:@"bg"]) {
            [images addObject:path];
        }
    }];

   
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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [images count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
    cell.topicLabel.text = [NSString stringWithFormat:@"#%@", topic];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.imageName = images[indexPath.row];
    cell.customImage.image = [UIImage imageNamed:cell.imageName];
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    self.navigationItem.title = @"Image Selected";
    imageName = cell.imageName;
    self.selectedImageBool = YES;
    
    NSLog(imageName);
}

-(void)selectedImage
{
    NewTopicController *newTopicVC = [[NewTopicController alloc] init];
    if(!self.selectedImageBool)
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Select an image" message:@"Please pick an image" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
    }
    if(!isLive && selectedImageBool)
    {
        [newTopicVC createTopic:topic prompt:prompt imageNamed:imageName isLive:NO];
        [self performSegueWithIdentifier:@"BackToThreads" sender:self];
        PFPush *push = [[PFPush alloc] init];
        PFQuery *query = [PFQuery queryWithClassName:@"_Installation"];
        [query whereKey:@"authorized" equalTo:[NSNumber numberWithBool:YES]];
        [push setQuery:query];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSString stringWithFormat:@"#%@ needs approval.", topic], @"alert",
                                    @"default", @"sound",
                                    nil];
        [push setData:dictionary];
        [push sendPushInBackground];

    }
    else if(selectedImageBool)
    {
        [newTopicVC createTopic:topic prompt:prompt imageNamed:imageName isLive:YES];
        [self performSegueWithIdentifier:@"BackToThreads" sender:self];
        PFPush *push = [[PFPush alloc] init];
        PFQuery *query = [PFQuery queryWithClassName:@"_Installation"];
        [query whereKey:@"authorized" equalTo:[NSNumber numberWithBool:YES]];
        [push setQuery:query];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSString stringWithFormat:@"#%@ needs approval.", topic], @"alert",
                                    @"default", @"sound",
                                    nil];
        [push setData:dictionary];
        [push sendPushInBackground];

    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    ThreadsFeedController *viewController = segue.destinationViewController;
    viewController.comingBack = YES;
    // Pass the selected object to the new view controller.
}



@end

