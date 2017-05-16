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

-(void) fetchTracksURLwithComplete:(CompletionBlock) completion {
    [[PageUtil sharedInstance] loadPage:[PathUtil urlAppendToBase:self.videoURL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 if(content != nil) {
                                     NSError *error = nil;
                                     HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
                                     if(error) {
                                         completion(nil, error);
                                         return;
                                     }
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
                                         [self.tracks addObject:track];
                                         
                                         NSString *dataSources = [videoNode getAttributeNamed:@"data-sources"];
                                         id json = [dataSources objectFromJSONString];
                                         //[JSONDecoder obj]
                                         if(json) {
                                             NSArray *tracks = json;
                                             for(NSDictionary *dict in tracks) {
                                                 TrackItem *track = [[TrackItem alloc] init];
                                                 track.dataSrc = [dict objectForKey:@"Src"];
                                                 track.dataType = [dict objectForKey:@"Type"];
                                                 track.dataInfo = [dict objectForKey:@"DataInfo"];
                                                 [self.tracks addObject:track];
                                             }
                                             
                                             NSLog(@"");
                                         }
                                     }
                                     
                                     completion(nil, nil);
                                 }
                                 
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
