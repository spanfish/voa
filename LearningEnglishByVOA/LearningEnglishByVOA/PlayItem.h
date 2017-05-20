//
//  PlayItem.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/08.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import <Realm/Realm.h>
#import "TrackItem.h"

@interface PlayItem : RLMObject {
}

@property(nonatomic, strong) NSString *videoTitle;
@property(nonatomic, strong) NSString *thumbURL;
@property(nonatomic, strong) NSString *videoURL;
@property(nonatomic, strong) NSString *publishDate;
@property(nonatomic, strong) NSString *sortedDate;
@property(nonatomic, assign) NSInteger targetType;
@property(nonatomic, assign, readonly, getter=hasFetchedTracksURL) BOOL fetchedTracksURL;

@property RLMArray<TrackItem *><TrackItem> *tracks;

-(NSURLSessionDataTask *) fetchTracksURLwithComplete:(CompletionBlock) completion;
-(NSURLSessionDownloadTask*) fetchThumbnailToPath:(NSString *) path withCompletion:(CompletionBlock) completion;
@end
