//
//  MenuTableViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/11.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "MenuTableViewController.h"
#import "EIAMCollectionViewController.h"

#import "AppDelegate.h"
static NSString* IMAGES[] = {
                        @"minute",
                        @"movie",
                        @"grammar",
                        @"television",
                        @"learnEnglish",
                        @"newWords",
                        @"people"};

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate {
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return sizeof(VIDEOS)/sizeof(NSString *);
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EIMCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:IMAGES[indexPath.row]];
        cell.textLabel.text = VIDEOS[indexPath.row];
        return cell;
    } else {
        if(indexPath.section == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StorageCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"disk"];
            cell.textLabel.text = @"Storage";
            return cell;
        } else if(indexPath.section == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"settings"];
            cell.textLabel.text = @"Settings";
            return cell;
//        } else if(indexPath.section == 3) {
//            //
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayList" forIndexPath:indexPath];
//            cell.imageView.image = [UIImage imageNamed:@"playlist"];
//            cell.textLabel.text = @"Now Playing";
//            return cell;
        } else if(indexPath.section == 3) {
            //
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Download" forIndexPath:indexPath];
            //cell.imageView.image = [UIImage imageNamed:@"playlist"];
            
            AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
            cell.textLabel.text = @"Downloading";
            if([appDelegate numberOfDownloadTask] > 0) {
                cell.imageView.image = [UIImage imageNamed:@"download"];
//                cell.imageView.animationImages = @[
//                                                   [UIImage imageNamed:@"more"],
//                                                   [UIImage imageNamed:@"more_loading_1"],
//                                                   [UIImage imageNamed:@"more_loading_2"],
//                                                   [UIImage imageNamed:@"more_loading_3"]
//                                                   ];
//                cell.imageView.animationDuration = 1.2;
//                [cell.imageView startAnimating];
            } else {
                //[cell.imageView stopAnimating];
                //cell.imageView.animationImages = nil;
                cell.imageView.image = [UIImage imageNamed:@"download"];
            }
            return cell;
        }
    }
    
    return nil;
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

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"didSelectRowAtIndexPath");
//}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue.identifier:%@", segue.identifier);
    if([segue.identifier isEqualToString:@"EnglishInAMinute"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *nvc = (UINavigationController *) segue.destinationViewController;
        EIAMCollectionViewController *vc = (EIAMCollectionViewController*) [nvc.viewControllers firstObject];
        vc.targetType = indexPath.row;
//        if(indexPath.row == 0) {
//            vc.targetType = TARGET_MINUTE;
//        } else if(indexPath.row == 1) {
//            vc.targetType = TARGET_MOVIE;
//        } else if(indexPath.row == 2) {
//            vc.targetType = TARGET_GRAMMAR;
//        } else if(indexPath.row == 3) {
//            vc.targetType = TARGET_ENGLISH_TV;
//        } else if(indexPath.row == 4) {
//            vc.targetType = TARGET_LEARN_ENGLISH;
//        } else if(indexPath.row == 5) {
//            vc.targetType = TARGET_NEW_WORDS;
//        } else if(indexPath.row == 6) {
//            vc.targetType = TARGET_PEOPLE;
//        }
    }
}


@end
