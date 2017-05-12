//
//  PlayItem.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/08.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@class TrackItem;
@interface PlayItem : NSObject {
    NSMutableArray<TrackItem*> *_allTracks;
}

@property(nonatomic, strong) NSString *uuid;
@property(nonatomic, strong) NSString *videoTitle;
@property(nonatomic, strong) NSString *thumbURL;
@property(nonatomic, strong) NSString *videoURL;
@property(nonatomic, strong) NSString *publishDate;
@property(nonatomic, strong, readonly) NSArray<TrackItem*> *tracks;
@property(nonatomic, assign, readonly, getter=hasFetchedTracksURL) BOOL fetchedTracksURL;

-(void) addTrack:(TrackItem *) track;
-(void) fetchTracksURLwithComplete:(CompletionBlock) completion;
@end
