//
//  EIAMCollectionViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "EIAMCollectionViewController.h"

@interface EIAMCollectionViewController () {
    EIAMDataSource *dataSource;
    NSMutableDictionary *_thumbFetchTasks;
    NSMutableDictionary *_trackFetchTasks;
    NSMutableDictionary *_videoFetchTasks;
}
@end

@implementation EIAMCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Learn English in a Minute";

    dataSource = [[EIAMDataSource alloc] init];
    dataSource.delegate = self;

    _thumbFetchTasks = [NSMutableDictionary dictionary];
    _trackFetchTasks = [NSMutableDictionary dictionary];
    _videoFetchTasks = [NSMutableDictionary dictionary];
    
    //取得动画列表
    [dataSource loadPage];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
}

-(void) showMenu:(id) sender {

    if([[SlideNavigationController sharedInstance] isMenuOpen]) {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    } else {
        [[SlideNavigationController sharedInstance] openMenu:MenuLeft
                                              withCompletion:^{
                                                  
                                              }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <EIAMDataSourceDelegate>
//动画列表取得完成
-(void) pageLoaded:(BOOL) hasMore withError:(NSError * _Nullable) error {
    main_queue([self.collectionView reloadData]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataSource.playItems count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EIAMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    //下一页
    if(indexPath.row == [dataSource.playItems count]) {
        cell.titleLabel.text = @"";
        cell.dateLabel.text = @"";
        cell.thumbImageView.image = [UIImage imageNamed:@"more-button"];
        return cell;
    }
    
    //显示一部动画的缩微图
    PlayItem *item = [dataSource.playItems objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.videoTitle;
    cell.dateLabel.text = item.publishDate;

    NSString *path = [PathUtil englishInAMinutePath];
    NSString *fileName = [path stringByAppendingPathComponent: [item.thumbURL lastPathComponent]];
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        //缩微图存在
        cell.thumbImageView.image = [UIImage imageWithContentsOfFile:fileName];
    } else {
        //缩微图不存在，开始下载
        [self loadThumbnail:item forIndexPath:indexPath];
    }

    BOOL videoExist = NO;
    unsigned long long fileSize = 0;
    for(NSInteger i = [item.tracks count] - 1; i >= 0; i--) {
        TrackItem *track = [item.tracks objectAtIndex:i];
        NSString *filePath = [path stringByAppendingPathComponent:[track.dataSrc lastPathComponent]];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            videoExist = YES;
            fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
            break;
        } else {
            //cell.sizeLabel.hidden = YES;
            cell.sizeLabel.text = @"";
            cell.downloadButton.hidden = NO;
        }
    }
    
    if(videoExist) {
        cell.sizeLabel.hidden = NO;
        cell.downloadButton.hidden = YES;
        cell.downloadIndicator.hidden = YES;
        
        if(fileSize/1024/1024 > 1) {
            cell.sizeLabel.text = [NSString stringWithFormat:@"%.1f M", (float)fileSize/1024/1024];
        } else if(fileSize/1024 > 1) {
            cell.sizeLabel.text = [NSString stringWithFormat:@"%.1f KB", (float)fileSize/1024];
        } else {
            cell.sizeLabel.text = [NSString stringWithFormat:@"%lld B", fileSize];
        }
    } else {
        [cell.downloadIndicator setBackgroundColor:[UIColor whiteColor]];
        [cell.downloadIndicator setFillColor:[UIColor lightGrayColor]];//[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
         [cell.downloadIndicator setStrokeColor:[UIColor lightGrayColor]];//[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
        [cell.downloadIndicator setClosedIndicatorBackgroundStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
        cell.downloadIndicator.radiusPercent = 0.45;
        [cell.downloadIndicator loadIndicator];
        
        cell.sizeLabel.hidden = YES;
        
        if([_trackFetchTasks objectForKey:indexPath] || [_videoFetchTasks objectForKey:indexPath]) {
            cell.downloadIndicator.hidden = NO;
            cell.downloadButton.hidden = YES;
        } else {
            cell.downloadIndicator.hidden = YES;
            cell.downloadButton.hidden = NO;
        }
    }

    return cell;
}

//下载动画的缩微图
-(void) loadThumbnail:(PlayItem *) item forIndexPath:(NSIndexPath *) indexPath {
    if([_thumbFetchTasks objectForKey:indexPath]) {
        NSLog(@"loadThumbnail in progress");
        return;
    }
    
    NSLog(@"loadThumbnail for row:%ld", (long)indexPath.row);
    NSTimeInterval s = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"image fetched start:%f", s);
    NSURLSessionDownloadTask *task = [item fetchThumbnailWithCompletion:^(id  _Nullable content, NSError * _Nullable error) {
        NSAssert([[NSThread currentThread] isMainThread], @"not in main thread");
        [_thumbFetchTasks removeObjectForKey:indexPath];
        NSLog(@"image fetched end:%f", [NSDate timeIntervalSinceReferenceDate] - s);

        NSString *thumbPath = [PathUtil englishInAMinutePath];
        NSString *fileName = [thumbPath stringByAppendingPathComponent: [item.thumbURL lastPathComponent]];
        if([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            //cell.thumbImageView.image = [UIImage imageWithContentsOfFile:fileName];
            //[cell setNeedsDisplay];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }];
    
    [_thumbFetchTasks setObject:task forKey:indexPath];
}
#pragma mark - <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < [dataSource.playItems count]) {
        PlayItem *item = [dataSource.playItems objectAtIndex:indexPath.row];
        NSLog(@"%@", item);

    }
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}


#pragma mark - EIAMCollectionViewCellDelegate
//播放动画
-(void) playTouchedWithItem:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if([_trackFetchTasks objectForKey:indexPath] || [_videoFetchTasks objectForKey:indexPath]) {
        return;
    }
    
    NSString *path = [PathUtil englishInAMinutePath];
    PlayItem *playItem = [dataSource.playItems objectAtIndex:indexPath.row];
    TrackItem *playTrack = nil;
    
    //从动画列表的最后（分辨率最高）开始找，如果找到动画文件，就直接播放
    for(NSInteger i = [playItem.tracks count] - 1; i >= 0; i--) {
        TrackItem *track = [playItem.tracks objectAtIndex:i];
        NSLog(@"track:%@\ndataInfo:%@\ndataSrc:%@",
              track.dataType,
              track.dataInfo,
              track.dataSrc);
        NSString *fileName = [track.dataSrc lastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:fileName] isDirectory:NULL]) {
            playTrack = track;
            break;
        }
    }
    if(playTrack != nil) {
        //找到动画文件,直接播放
        NSLog(@"play video");
    } else {
        //未找到动画文件
        NSLog(@"未找到动画文件");
        
        //Track列表已经取得了吗
        if([playItem.tracks count] == 0) {
            //download tracks
            NSLog(@"未找到Track列表");
            [self downloadTrackURLsWithItem:playItem forIndexPath:indexPath];
        } else {
            //download video for the track

            playTrack = [playItem.tracks lastObject];
            //[dataSource downloadTrack:playTrack];
        }
    }
}
//下载动画
-(void) downloadTouchedWithItem:(UICollectionViewCell *)cell {

}
//取得各个分辨率动画的URL
-(void) downloadTrackURLsWithItem:(PlayItem *)playItem forIndexPath:(NSIndexPath*) indexPath{
    if([playItem.tracks count] == 0) {
        NSLog(@"下载Track列表");
        if([_trackFetchTasks objectForKey:indexPath]) {
            return;
        }
        
        NSTimeInterval s = [NSDate timeIntervalSinceReferenceDate];
        NSLog(@"tracks url fetched start:%f", s);
        NSURLSessionDataTask *task = [playItem fetchTracksURLwithComplete:^(id  _Nullable content, NSError * _Nullable error) {
            NSLog(@"下载Track列表完成");
            NSLog(@"tracks url fetched start:%f", [NSDate timeIntervalSinceReferenceDate] - s);
            
            [_trackFetchTasks removeObjectForKey:indexPath];
            if(error == nil) {
                TrackItem *playTrack = [playItem.tracks lastObject];
                NSLog(@"下载mp4");
                NSTimeInterval s = [NSDate timeIntervalSinceReferenceDate];
                NSLog(@"mp4 fetched start:%f", s);
                NSURLSessionDownloadTask *videoTask = [playTrack fetchTrackWithProgress:^(int64_t totalBytes, int64_t downloadedBytes) {
                    NSAssert([[NSThread currentThread] isMainThread], @"not in main thread");
                    EIAMCollectionViewCell *cell = (EIAMCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
                    [cell.downloadIndicator updateWithTotalBytes:totalBytes downloadedBytes:downloadedBytes];
                    //[cell setNeedsDisplay];
                } complete:^(NSData * _Nullable content, NSError * _Nullable error) {
                    NSLog(@"*****************************下载mp4完成*****************************");
                    NSLog(@"mp4 fetched start:%f", [NSDate timeIntervalSinceReferenceDate] - s);
                    
                    [_videoFetchTasks removeObjectForKey:indexPath];
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
                [_videoFetchTasks setObject:videoTask forKey:indexPath];
                [videoTask resume];
            } else {
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }];
        [_trackFetchTasks setObject:task forKey:indexPath];
        [task resume];
    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}
@end
