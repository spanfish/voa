//
//  EIAMDataSource.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "EIAMDataSource.h"

#import <ObjectiveCHMTLParser/HTMLNode.h>
#import <ObjectiveCHMTLParser/HTMLParser.h>
#import <JSONKit/JSONKit.h>

#import "Common.h"

@interface EIAMDataSource() {
}
@end

@implementation EIAMDataSource

-(instancetype) init {
    self = [super init];
    if(self) {
        _playItems = [[PlayItem allObjects] sortedResultsUsingKeyPath:@"sortedDate" ascending:NO];
#if DEBUG
        for (PlayItem *item in _playItems) {
            NSLog(@"playItem:%@", item);
        }
#endif
    }
    return self;
}
//取得一页动画列表
-(void) loadPage {
    [[PageUtil sharedInstance] loadPage:@"http://learningenglish.voanews.com/z/3619"
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 global_queue([self parsePage:content]);
                             }];
}
//解析HTML
-(void) parsePage:(NSString *) pageContent {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:pageContent error:&error];
    if(error) {
        if([self.delegate respondsToSelector:@selector(pageLoaded:withError:)]) {
            [self.delegate pageLoaded:NO withError:error];
        }
        return;
    }
    HTMLNode *body = [parser body];
    HTMLNode *itemsNode = [body findChildWithAttribute:@"id" matchingName:@"items" allowPartial:NO];
    if(itemsNode) {
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"_w[0-9]{2,5}_" options:0 error:&error];
        
        for(HTMLNode *item in [itemsNode findChildrenWithAttribute:@"class" matchingName:@"media-block with-date width-img size-3" allowPartial:YES]) {
            //URL
            HTMLNode *urlNode = [item findChildWithAttribute:@"class" matchingName:@"img-wrap" allowPartial:NO];
            NSLog(@"href=%@", [urlNode getAttributeNamed:@"href"]);
            //thumb
            HTMLNode *thumbNode = [item findChildWithAttribute:@"class" matchingName:@"thumb" allowPartial:YES];
            thumbNode = [thumbNode findChildTag:@"img"];
            NSLog(@"thumb=%@", [thumbNode getAttributeNamed:@"src"]);
            //date
            HTMLNode *dateNode = [item findChildWithAttribute:@"class" matchingName:@"date" allowPartial:NO];
            NSLog(@"date=%@", [dateNode contents]);
            //title
            HTMLNode *titleNode = [item findChildWithAttribute:@"class" matchingName:@"title" allowPartial:NO];
            NSLog(@"title=%@", [titleNode contents]);
            
            PlayItem *playItem = [[PlayItem alloc] init];
            if(urlNode) {
                playItem.videoURL = [urlNode getAttributeNamed:@"href"];
                
                if(thumbNode) {
                    playItem.thumbURL = [thumbNode getAttributeNamed:@"src"];

                    NSTextCheckingResult *match = [regexp firstMatchInString:playItem.thumbURL options:0 range:NSMakeRange(0, playItem.thumbURL.length)];
                    if(match.numberOfRanges > 0 && match.range.location != NSNotFound) {
                        playItem.thumbURL = [playItem.thumbURL stringByReplacingCharactersInRange:match.range withString:@"_w408_"];
                    }
                }
                
                if(dateNode) {
                    playItem.publishDate = [dateNode contents];
                }
                
                if(titleNode) {
                    playItem.videoTitle = [titleNode contents];
                    if([playItem.videoTitle hasPrefix:@"English in a Minute: "]) {
                        playItem.videoTitle = [playItem.videoTitle substringFromIndex:[@"English in a Minute: " length]];
                    }
                }
                if([self.delegate respondsToSelector:@selector(playItemFound:)]) {
                    main_queue([self notifyUI:playItem]);
                }
            }
        }//end of for
    }
    
    HTMLNode *moreNode = [body findChildWithAttribute:@"class" matchingName:@"link-showMore" allowPartial:YES];
    if([self.delegate respondsToSelector:@selector(pageLoaded:withError:)]) {
        [self.delegate pageLoaded:moreNode != nil withError:error];
    }
}
//存储到DB，并更新UI
-(void) notifyUI:(PlayItem*) playItem {
    if([PlayItem objectForPrimaryKey:playItem.videoTitle] == nil) {
        //May 13, 2017
        NSArray *tmp = [playItem.publishDate componentsSeparatedByString:@","];
        if([tmp count] == 2) {
            NSString *year = [tmp objectAtIndex:1];
            tmp = [[tmp objectAtIndex:0] componentsSeparatedByString:@" "];
            if([tmp count] == 2) {
                NSInteger day = [[tmp objectAtIndex:1] integerValue];
                NSString * month = 0;
                if([@"Jan" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"01";
                } else if([@"Feb" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"02";
                } else if([@"Mar" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"03";
                } else if([@"Apr" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"04";
                } else if([@"May" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"05";
                } else if([@"Jun" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"06";
                } else if([@"Jul" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"07";
                } else if([@"Aug" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"08";
                } else if([@"Sep" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"09";
                } else if([@"Oct" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"10";
                } else if([@"Nov" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"11";
                } else if([@"Dec" isEqualToString:[tmp objectAtIndex:0]]) {
                    month = @"12";
                }
                
                playItem.sortedDate = [NSString stringWithFormat:@"%@-%@-%02ld", year, month, (long)day];
            }
        }
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [[RLMRealm defaultRealm] addOrUpdateObject:playItem];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        
        [self.delegate playItemFound:playItem];
    }
}
/*
 <a class="btn link-showMore btn-anim" data-ajax="true" data-ajax-method="GET" data-ajax-mode="after" data-ajax-update="#items" data-ajax-url="/z/3619?p=2" href="/z/3619?p=2">Load more</a>
*/
-(void) fetchTracksURLforPlayItem:(PlayItem *) playItem withComplete:(CompletionBlock) completion {
    [[PageUtil sharedInstance] loadPage:[PathUtil urlAppendToBase:playItem.videoURL]
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
                                             
                                             NSLog(@"");
                                         }
                                     }
                                     [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                         TrackItem *track1 = obj1;
                                         TrackItem *track2 = obj2;
                                         return [track1.dataInfo compare:track2.dataInfo];
                                     }];
                                     completion(array, nil);
                                 } else {
                                     completion(nil, nil);
                                 }
                             }];
}

-(void) downloadTrack:(TrackItem *) item {
    NSString *englishInAMinitueCacheDir = [PathUtil englishInAMinutePath];
    NSString *fileName = [item.dataSrc lastPathComponent];
    [[PageUtil sharedInstance] downloadData:item.dataSrc
                                     toFile:[englishInAMinitueCacheDir stringByAppendingPathComponent:fileName]
                                   progress:^(int64_t totalBytes, int64_t downloadedBytes) {
                                       [self.delegate downloadProgress:downloadedBytes inTotal:totalBytes];
                                   }
                                 completion:^(NSData * _Nullable content, NSError * _Nullable error) {
                                     main_queue([self.delegate videoDownloaded:item]);
                                 }];
}

-(void) downloadPlayItemThumb:(PlayItem *) item forIndexPath:(NSIndexPath *) indexPath {
    NSString *englishInAMinitueCacheDir = [PathUtil englishInAMinutePath];
    NSString *fileName = [item.thumbURL lastPathComponent];
    
    [[PageUtil sharedInstance] downloadData:item.thumbURL
                                     toFile:[englishInAMinitueCacheDir stringByAppendingPathComponent:fileName]
                                 completion:^(NSData * _Nullable content, NSError * _Nullable error) {
                                     if([self.delegate respondsToSelector:@selector(thumbnailDidDownloadForPlayItem:atIndexPath:withError:)]) {
                                         main_queue([self.delegate thumbnailDidDownloadForPlayItem:item atIndexPath:indexPath withError:error]);
                                     }
                                 }];
}

-(void) saveTracks:(NSArray *) array forPlayItem:(PlayItem *) playItem {
    main_queue([self internalSaveTracks:array forPlayItem:playItem]);
}

-(void) internalSaveTracks:(NSArray *) array forPlayItem:(PlayItem *) playItem {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    for (TrackItem *track in array) {
        [playItem.tracks addObject:track];
    }
    [[RLMRealm defaultRealm] addOrUpdateObject:playItem];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}
@end
