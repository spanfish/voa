//
//  DownloadingTableViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/23.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "DownloadingTableViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "AppDelegate.h"
#import "NSLayoutConstraint+Multiplier.h"

@interface DownloadingTableViewController () {
    NSMutableArray *downloadArray;
}
@end

@implementation DownloadingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Downloading";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController ) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    downloadArray = [NSMutableArray array];
    
    NSDictionary *dict = [appDelegate.downloadDict copy];
    NSEnumerator<NSString *> *keys = [dict keyEnumerator];
    NSString *key = nil;
    while((key = [keys nextObject]) != nil) {
        [downloadArray addObject:[dict objectForKey:key]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDownloadCompleted:) name:@"VideoDownloadCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDownloadProgressed:) name:@"VideoDownloadProgressed" object:nil];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [downloadArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadingTableViewCell *cell = (DownloadingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //PlayItem *playItem = [downloadArray objectAtIndex:indexPath.row];
    [cell.widthRatioConstraint updateMultiplier: 7.0/3];
    //cell.titleLabel.text = playItem.videoTitle;
    return cell;
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


-(void) videoDownloadCompleted:(NSNotification *) notification {
    NSAssert([NSThread isMainThread], @"not in main thread");
//    NSString *url = [[notification userInfo] objectForKey:@"videoURL"];
//    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
//    [appDelegate removeDownloadTaskForKey:url];
//    
//    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
//        PlayItem *playItem = [dataSource.playItems objectAtIndex:indexPath.row];
//        
//        for(NSInteger i = [playItem.tracks count] - 1; i >= 0; i--) {
//            TrackItem *track = [playItem.tracks objectAtIndex:i];
//            
//            if([track.dataSrc isEqualToString:url]) {
//                NSLog(@"videoDownloadCompleted:%ld", indexPath.row);
//                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                break;
//            }
//        }
//    }
}

-(void) videoDownloadProgressed:(NSNotification *) notification {
    NSAssert([NSThread isMainThread], @"not in main thread");
//    NSString *url = [[notification userInfo] objectForKey:@"videoURL"];
//    int64_t totalBytes = [[[notification userInfo] objectForKey:@"totalUnitCount"] longLongValue];
//    int64_t downloadedBytes = [[[notification userInfo] objectForKey:@"completedUnitCount"] longLongValue];
//    
//    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
//        if(indexPath.section != 0) {
//            continue;
//        }
//        PlayItem *playItem = [dataSource.playItems objectAtIndex:indexPath.row];
//        
//        for(NSInteger i = [playItem.tracks count] - 1; i >= 0; i--) {
//            TrackItem *track = [playItem.tracks objectAtIndex:i];
//            
//            if([track.dataSrc isEqualToString:url]) {
//                NSLog(@"videoDownloadProgressed:%ld", indexPath.row);
//                EIAMCollectionViewCell *cell = (EIAMCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
//                [cell.downloadIndicator updateWithTotalBytes:totalBytes downloadedBytes:downloadedBytes];
//                //[cell.downloadIndicator setNeedsDisplay];
//                break;
//            }
//        }
//    }
}
@end

@implementation DownloadingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
