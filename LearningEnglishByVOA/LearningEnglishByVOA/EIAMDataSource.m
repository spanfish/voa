//
//  EIAMDataSource.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "EIAMDataSource.h"
#import "PageUtil.h"
#import <ObjectiveCHMTLParser/HTMLNode.h>
#import <ObjectiveCHMTLParser/HTMLParser.h>
#import <JSONKit/JSONKit.h>

#import "PlayItem.h"

@interface EIAMDataSource() {
    NSMutableArray<PlayItem *> *_items;
}
@end

@implementation EIAMDataSource

-(instancetype) init {
    self = [super init];
    if(self) {
        _items = [NSMutableArray array];
    }
    return self;
}
-(void) loadPage {
    [[PageUtil sharedInstance] loadPage:@"http://learningenglish.voanews.com/z/3619"
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 if(content != nil) {
                                     [self parsePage:content];
                                 }
                                 if([self.delegate respondsToSelector:@selector(pageLoadedWithError:)]) {
                                     [self.delegate pageLoadedWithError:error];
                                 }
                             }];
}

-(void) parsePage:(NSString *) pageContent {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:pageContent error:&error];
    if(error) {
        //
        return;
    }
    HTMLNode *body = [parser body];
    HTMLNode *itemsNode = [body findChildWithAttribute:@"id" matchingName:@"items" allowPartial:NO];
    if(itemsNode) {
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
                }
                
                if(dateNode) {
                    playItem.publishDate = [dateNode contents];
                }
                
                if(titleNode) {
                    playItem.videoTitle = [titleNode contents];
                }
                
                [_items addObject:playItem];
            }
        }//end of for
        if([_items count] > 0) {
            [self downloadPlayItem:nil];
        }
    }
}

-(void) loadPlayItemTracks:(PlayItem *) item {
    [[PageUtil sharedInstance] loadPage:[NSString stringWithFormat:@"http://learningenglish.voanews.com%@", item.videoURL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 if(content != nil) {
                                     NSError *error = nil;
                                     HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&error];
                                     if(error) {
                                         //
                                         return;
                                     }
                                     HTMLNode *body = [parser body];
                                     HTMLNode *videoNode = [body findChildTag:@"video"];
                                     if(videoNode) {
                                         NSString *src = [videoNode getAttributeNamed:@"src"];
                                         NSString *dataType = [videoNode getAttributeNamed:@"data-type"];
                                         NSString *dataInfo = [videoNode getAttributeNamed:@"data-info"];
                                         
                                         NSString *dataSources = [videoNode getAttributeNamed:@"data-sources"];
                                         //[dataSources objectf]
                                         //[JSONDecoder obj]
                                     }
                                 }
                                 
                             }];
}

-(void) downloadPlayItem:(PlayItem *) item {
    //
    [[PageUtil sharedInstance] downloadVideoFile:@"https://av.voanews.com/Videoroot/Pangeavideo/2016/10/f/f4/f494cf01-c26c-4025-9fee-11e234d181be.mp4"
                                      completion:^(NSData * _Nullable content, NSError * _Nullable error) {
                                          if(content != nil) {
                                              NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                                              if(!error) {
                                                  [content writeToFile:[path stringByAppendingPathComponent:@"f494cf01-c26c-4025-9fee-11e234d181be.mp4"] atomically:YES];
                                              }
                                          }
                                      }];
}
@end
