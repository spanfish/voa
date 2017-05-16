//
//  EIAMDataSource.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageUtil.h"
#import "PlayItem.h"
#import "TrackItem.h"
#import "PathUtil.h"

@protocol EIAMDataSourceDelegate<NSObject>

-(void) videoDownloaded:(TrackItem *) trackItem;
-(void) playItemFound:(PlayItem *) playItem;
-(void) pageLoaded:(BOOL) hasMore withError:(NSError *) error;
-(void) thumbnailDidDownloadForPlayItem:(PlayItem *) item atIndexPath:(NSIndexPath *) indexPath withError:(NSError *) error;
-(void) downloadProgress:(NSUInteger) downloadedBytes inTotal:(NSUInteger) totalBytes;
@end

@interface EIAMDataSource : NSObject

@property(nonatomic, weak) id<EIAMDataSourceDelegate> delegate;
@property(nonatomic, strong) RLMResults<PlayItem *> *playItems;
-(void) loadPage;
//Download thumbnail for video item.
-(void) downloadPlayItemThumb:(PlayItem *) item forIndexPath:(NSIndexPath *) indexPath;
-(void) downloadTrack:(TrackItem *) item;

-(void) fetchTracksURLforPlayItem:(PlayItem *) playItem withComplete:(CompletionBlock) completion;

-(void) saveTracks:(NSArray *) array forPlayItem:(PlayItem *) playItem;
@end
