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
        }
    }
}
@end
