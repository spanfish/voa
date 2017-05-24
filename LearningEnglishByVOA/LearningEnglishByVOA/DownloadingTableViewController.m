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
#import "PathUtil.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDownloadCompleted:) name:@"DownloadCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDownloadProgressed:) name:@"DownloadProgressed" object:nil];
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
    PlayItem *playItem = [downloadArray objectAtIndex:indexPath.row];

    cell.titleLabel.text = playItem.videoTitle;
    
    
    
    cell.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;

    NSString *thumbPath = [PathUtil pathForThumb];
    NSString *fileName = [thumbPath stringByAppendingPathComponent: [playItem.thumbURL lastPathComponent]];
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        //缩微图存在
        cell.thumbnailImageView.image = [UIImage imageWithContentsOfFile:fileName];
    } else {
        cell.thumbnailImageView.image = nil;
    }
    
    NSString *path = [PathUtil pathForType:playItem.targetType];
    BOOL videoExist = NO;
    for(NSInteger i = [playItem.tracks count] - 1; i >= 0; i--) {
        TrackItem *track = [playItem.tracks objectAtIndex:i];
        NSString *filePath = [path stringByAppendingPathComponent:[track.dataSrc lastPathComponent]];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            videoExist = YES;
            break;
        }
    }
    cell.slider.maximumValue = 1;
    cell.slider.minimumValue = 0;
    
    if(videoExist) {
        cell.slider.value = 1;
    } else {
        cell.slider.value = 0;
    }
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
    NSString *videoTitle = [[notification userInfo] objectForKey:@"videoTitle"];
    
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        PlayItem *playItem = [downloadArray objectAtIndex:indexPath.row];
        if([playItem.videoTitle isEqualToString:videoTitle]) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

-(void) videoDownloadProgressed:(NSNotification *) notification {
    NSAssert([NSThread isMainThread], @"not in main thread");
    //NSString *videoURL = [[notification userInfo] objectForKey:@"videoURL"];
    NSString *videoTitle = [[notification userInfo] objectForKey:@"videoTitle"];
    int64_t totalBytes = [[[notification userInfo] objectForKey:@"totalUnitCount"] longLongValue];
    int64_t downloadedBytes = [[[notification userInfo] objectForKey:@"completedUnitCount"] longLongValue];
    
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        PlayItem *playItem = [downloadArray objectAtIndex:indexPath.row];
        if([playItem.videoTitle isEqualToString:videoTitle]) {
            DownloadingTableViewCell *cell = (DownloadingTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
            cell.slider.value = (float)downloadedBytes/totalBytes;
            break;
        }
    }
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

    [self.slider setThumbImage:[[UIImage imageNamed:@"Transparency10"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[[UIImage imageNamed:@"slider-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[[UIImage imageNamed:@"slider-maximum"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
