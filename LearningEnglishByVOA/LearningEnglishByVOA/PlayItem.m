//
//  PlayItem.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/08.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "PlayItem.h"
#import "TrackItem.h"
#import "PageUtil.h"
#import "PathUtil.h"
#import <ObjectiveCHMTLParser/HTMLNode.h>
#import <ObjectiveCHMTLParser/HTMLParser.h>
#import <JSONKit/JSONKit.h>

@implementation PlayItem
-(instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}

+ (NSString *)primaryKey {
    return @"videoTitle";
}

+ (NSArray *)indexedProperties {
    return @[@"index"];
}

+ (NSArray *)ignoredProperties {
    return @[@"fetchedTracksURL"];
}

/*
-(void) addTrack:(TrackItem *) track {
    [_allTracks addObject:track];
    [_allTracks sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TrackItem *item1 = obj1;
        TrackItem *item2 = obj2;
        
        return [item2.dataInfo compare:item1.dataInfo];
    }];
}

-(NSArray<TrackItem*> *) tracks {
    return _allTracks;
}
*/
-(BOOL)hasFetchedTracksURL {
    return [_tracks count] > 0;
}

-(NSURLSessionDataTask *) fetchTracksURLwithComplete:(CompletionBlock) completion {
    return [[PageUtil sharedInstance] loadPage:[PathUtil urlAppendToBase:self.videoURL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 if(content != nil) {
                                     NSError *error = nil;
                                     HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
                                     if(error) {
                                         completion(nil, error);
                                         return;
                                     }
                                     
                                     NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
                                     HTMLNode *body = [parser body];
                                     HTMLNode *videoNode = [body findChildTag:@"video"];
                                     if(videoNode) {
                                         NSString *src = [videoNode getAttributeNamed:@"src"];
                                         NSString *dataType = [videoNode getAttributeNamed:@"data-type"];
                                         NSString *dataInfo = [videoNode getAttributeNamed:@"data-info"];
                                         
                                         TrackItem *track = [[TrackItem alloc] init];
                                         track.dataSrc = src;
                                         track.dataType = dataType;
                                         track.dataInfo = dataInfo;
                                         
                                         [array addObject:track];
                                         
                                         NSString *dataSources = [videoNode getAttributeNamed:@"data-sources"];
                                         id json = [dataSources objectFromJSONString];
                                         
                                         if(json) {
                                             NSArray *tracks = json;
                                             for(NSDictionary *dict in tracks) {
                                                 TrackItem *track = [[TrackItem alloc] init];
                                                 track.dataSrc = [dict objectForKey:@"Src"];
                                                 track.dataType = [dict objectForKey:@"Type"];
                                                 track.dataInfo = [dict objectForKey:@"DataInfo"];
                                                 [array addObject:track];
                                             }
                                         }
                                     }
                                     [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                         TrackItem *track1 = obj1;
                                         TrackItem *track2 = obj2;
                                         return [track1.dataInfo compare:track2.dataInfo];
                                     }];
                                     
                                     [[RLMRealm defaultRealm] beginWriteTransaction];
                                     for (TrackItem *track in array) {
                                         [self.tracks addObject:track];
                                     }
                                     [[RLMRealm defaultRealm] addOrUpdateObject:self];
                                     [[RLMRealm defaultRealm] commitWriteTransaction];
                                     
                                     completion(array, nil);
                                 } else {
                                     completion(nil, nil);
                                 }
                             }];
}

-(NSURLSessionDownloadTask*) fetchThumbnailWithCompletion:(CompletionBlock)completion {
    NSString *englishInAMinitueCacheDir = [PathUtil englishInAMinutePath];
    NSString *fileName = [self.thumbURL lastPathComponent];
    return [[ImageUtil sharedInstance] fetchImage:self.thumbURL
                                    toFile:[englishInAMinitueCacheDir stringByAppendingPathComponent:fileName]
                                  progress:nil
                                completion:^(NSData * _Nullable content, NSError * _Nullable error) {completion(nil, error);
                                  }];
}

-(NSString *) description {
    NSMutableString *desc = [NSMutableString stringWithFormat: @"%@\nthumbURL:%@\nvideoURL:%@\ndate:%@\ntracks:%ld",
            _videoTitle,
            _thumbURL,
            _videoURL,
            _publishDate,
                             (long)[_tracks count]];

    return desc;
}
@end
