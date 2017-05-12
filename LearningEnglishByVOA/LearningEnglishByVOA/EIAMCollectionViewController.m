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
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    dataSource = [[EIAMDataSource alloc] init];
    dataSource.delegate = self;
    [dataSource loadPage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <EIAMDataSourceDelegate>
-(void) pageLoaded:(BOOL) hasMore withError:(NSError * _Nullable) error {
    [self.collectionView reloadData];
}

-(void) thumbnailDidDownloadForPlayItem:(PlayItem *) item atIndexPath:(NSIndexPath *) indexPath withError:(NSError *) error {
    //[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    EIAMCollectionViewCell *cell = (EIAMCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    //if(item == [dataSource.videoArray objectAtIndex:indexPath.row]) {
    NSString *thumbPath = [PathUtil englishInAMinutePath];
    NSString *fileName = [thumbPath stringByAppendingPathComponent: [item.thumbURL lastPathComponent]];
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        cell.thumbImageView.image = [UIImage imageWithContentsOfFile:fileName];
    }
    //}
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
    return [dataSource.videoArray count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EIAMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == [dataSource.videoArray count]) {
        cell.titleLabel.text = @"";
        cell.dateLabel.text = @"";
        cell.thumbImageView.image = [UIImage imageNamed:@"more-button"];
        return cell;
    }
    
    PlayItem *item = [dataSource.videoArray objectAtIndex:indexPath.row];
    // Configure the cell
    cell.titleLabel.text = item.videoTitle;
    cell.dateLabel.text = item.publishDate;
    
    NSLog(@"thumbURL:%@", item.thumbURL);
    NSString *thumbPath = [PathUtil englishInAMinutePath];
    NSString *fileName = [thumbPath stringByAppendingPathComponent: [item.thumbURL lastPathComponent]];
    if([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        cell.thumbImageView.image = [UIImage imageWithContentsOfFile:fileName];
    } else {
        [self loadThumbnail:item forIndexPath:indexPath];
    }
    return cell;
}

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
    if(indexPath.row < [dataSource.videoArray count]) {
        PlayItem *item = [dataSource.videoArray objectAtIndex:indexPath.row];
        NSLog(@"%@", item);

    }
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

-(IBAction)downloadButtonTouched:(id) sender {
    //NSLog(@"recognizer:%@ view:%@", recognizer, recognizer.view);
    UIView *view = sender;
    while(view != nil) {
        if([view isKindOfClass:[UICollectionViewCell class]]) {
            break;
        }
        view = [view superview];
    }
    
    NSLog(@"view:%@", view);
    if(view != nil) {
        UICollectionViewCell *cell = (UICollectionViewCell*) view;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        if(indexPath.row < [dataSource.videoArray count]) {
            PlayItem *item = [dataSource.videoArray objectAtIndex:indexPath.row];
            NSLog(@"%@", item);
#if DEBUG
            for(TrackItem *track in item.tracks) {
                NSLog(@"track:%@", track);
            }
#endif
            if(!item.hasFetchedTracksURL) {
                [item fetchTracksURLwithComplete:^(NSString * _Nullable content, NSError * _Nullable error) {
                    if(error) {
                        
                    } else {
                        TrackItem *track = [item.tracks lastObject];
                        if(track && !track.hasDownloaded) {
                            [track fetchTrackWithComplete:^(NSData * _Nullable content, NSError * _Nullable error) {
                                if(error) {
                                    
                                } else {
                                    
                                }
                            }];
                        }
                    }
                }];
            }
        }
    }
}
@end
