//
//  SettingsTableViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/19.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SWRevealViewController.h"
#import "VideoQualityViewController.h"

typedef NS_ENUM(NSInteger, SettingType) {
    VIDEO_SETTING,
    OTHER_SETTING,
    NUM_OF_SECTION
};

static int ROWS[] = {1, 2};

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController ) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
        
        //http://www.appcoda.com/ios-programming-sidebar-navigation-menu/
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUM_OF_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ROWS[section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == VIDEO_SETTING) {
        if(indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoQualityCell" forIndexPath:indexPath];
            
            NSString *currentQuality = [[NSUserDefaults standardUserDefaults] objectForKey:@"VideoQuality"];
            if(currentQuality == nil) {
                currentQuality = @"720p";
            }
            cell.detailTextLabel.text = currentQuality;
            return cell;
        }
    } else if(indexPath.section == OTHER_SETTING) {
        if(indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VersionCell" forIndexPath:indexPath];
            
            return cell;
        }
        
        if(indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
            
            return cell;
        }
    }
    
    return nil;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == VIDEO_SETTING) {
        return @"Video";
    } else if(section == OTHER_SETTING) {
        return @"Others";
    }
    
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == OTHER_SETTING && indexPath.row == 1) {
#if DEBUG
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/app/etc%E6%98%8E%E7%B4%B0%E3%81%8F%E3%82%93/id1173315014?l=en&mt=8";
#else
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/app/voa-video/id1237124087?ls=1&mt=8";
#endif
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    } else if(indexPath.section == VIDEO_SETTING && indexPath.row == 0) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuailityViewController"];
        [self.navigationController pushViewController:vc animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
