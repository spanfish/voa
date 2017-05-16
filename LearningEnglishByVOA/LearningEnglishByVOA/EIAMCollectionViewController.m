//
//  EIAMCollectionViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "EIAMCollectionViewController.h"

#import "EIAMCollectionViewCell.h"
#import "PlayItem.h"
#import "TrackItem.h"

@interface EIAMCollectionViewController () {
    EIAMDataSource *dataSource;
}
@end

@implementation EIAMCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Learn English in a Minute";

    dataSource = [[EIAMDataSource alloc] init];
    dataSource.delegate = self;
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

#pragma mark <EIAMDataSourceDelegate>
-(void) playItemFound:(PlayItem *) playItem {
    //找到一部动画
    [self.collectionView reloadData];
}

-(void) pageLoaded:(BOOL) hasMore withError:(NSError * _Nullable) error {
    main_queue([self reloadView]);
}

-(void) reloadView {
    [self.collectionView reloadData];
}

-(void) thumbnailDidDownloadForPlayItem:(PlayItem *) item atIndexPath:(NSIndexPath *) indexPath withError:(NSError *) error {
    EIAMCollectionViewCell *cell = (EIAMCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSString *thumbPath = [PathUtil englishInAMinutePath];
    NSString *fileName = [thumbPath stringByAppendingPathComponent: [item.thumbURL lastPathComponent]];
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        cell.thumbImageView.image = [UIImage imageWithContentsOfFile:fileName];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataSource.playItems count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EIAMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == [dataSource.playItems count]) {
        cell.titleLabel.text = @"";
        cell.dateLabel.text = @"";
        cell.thumbImageView.image = [UIImage imageNamed:@"more-button"];
        return cell;
    }
    
    PlayItem *item = [dataSource.playItems objectAtIndex:indexPath.row];
    // Configure the cell
    cell.titleLabel.text = item.videoTitle;
    cell.dateLabel.text = item.publishDate;
#if DEBUG
    NSMutableString *desc = [NSMutableString stringWithFormat: @"%@\nthumbURL:%@\nvideoURL:%@\ndate:%@\ntracks:%ld",
                             item.videoTitle,
                             item.thumbURL,
                             item.videoURL,
                             item.publishDate,
                             (long)[item.tracks count]];
    NSLog(@"PlayItem:%@", desc);

#endif
    NSString *path = [PathUtil englishInAMinutePath];
    NSString *fileName = [path stringByAppendingPathComponent: [item.thumbURL lastPathComponent]];
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        cell.thumbImageView.image = [UIImage imageWithContentsOfFile:fileName];
    } else {
        [self loadThumbnail:item forIndexPath:indexPath];
    }

    for(NSInteger i = [item.tracks count] - 1; i >= 0; i--) {
        TrackItem *track = [item.tracks objectAtIndex:i];
        NSString *filePath = [path stringByAppendingPathComponent:[track.dataSrc lastPathComponent]];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            cell.sizeLabel.hidden = NO;
            cell.downloadButton.hidden = YES;
            
            unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
            if(fileSize/1024/1024 > 1) {
                cell.sizeLabel.text = [NSString stringWithFormat:@"%.1f M", (float)fileSize/1024/1024];
            } else if(fileSize/1024 > 1) {
                cell.sizeLabel.text = [NSString stringWithFormat:@"%.1f KB", (float)fileSize/1024];
            } else {
                cell.sizeLabel.text = [NSString stringWithFormat:@"%lld B", fileSize];
            }
            break;
        } else {
            //cell.sizeLabel.hidden = YES;
            cell.sizeLabel.text = @"";
            cell.downloadButton.hidden = NO;
        }
    }
    
    [cell.downloadIndicator setBackgroundColor:[UIColor whiteColor]];
    [cell.downloadIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [cell.downloadIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [cell.downloadIndicator setClosedIndicatorBackgroundStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    cell.downloadIndicator.radiusPercent = 0.45;
    [cell.downloadIndicator loadIndicator];
    
    cell.delegate = self;
    cell.playItem = item;
    
    return cell;
}

//下载动画的thumbnail
-(void) loadThumbnail:(PlayItem *) item forIndexPath:(NSIndexPath *) indexPath {
    [dataSource downloadPlayItemThumb:item forIndexPath:indexPath];
}
#pragma mark <UICollectionViewDelegate>

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
-(void) playTouchedWithItem:(PlayItem *)playItem {
    NSString *path = [PathUtil englishInAMinutePath];
    
    TrackItem *playTrack = nil;
    
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
        NSLog(@"play video");
    } else {
        if([playItem.tracks count] == 0) {
            //download tracks
            [self downloadTrackURLsWithItem:playItem];
        } else {
            //download video for the track
            playTrack = [playItem.tracks lastObject];
            [dataSource downloadTrack:playTrack];
        }
    }
}

-(void) downloadTrackURLsWithItem:(PlayItem *)playItem {
    if([playItem.tracks count] == 0) {
        [dataSource fetchTracksURLforPlayItem:playItem withComplete:^(id  _Nullable content, NSError * _Nullable error) {
            NSArray *tracks = content;
            if(tracks) {
                [dataSource saveTracks:tracks forPlayItem:playItem];
            }
        }];
    }
}

-(void) downloadProgress:(NSUInteger) downloadedBytes inTotal:(NSUInteger) totalBytes {
    
}

-(void) videoDownloaded:(TrackItem *) trackItem {
    NSLog(@"videoDownloaded");
}
@end
