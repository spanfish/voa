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
    }
    return self;
}
//取得一页动画列表
-(void) loadPage:(NSString *) moreURL {
    //@"http://learningenglish.voanews.com/z/3619"
    [[PageUtil sharedInstance] loadPage:[PathUtil urlAppendToBase: moreURL.length > 0 ? moreURL : @"/z/3619"]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 NSAssert([[NSThread currentThread] isMainThread], @"Not main thread");
                                 [self parsePage:content];
                             }];
}
//解析HTML
-(void) parsePage:(NSString *) pageContent {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:pageContent error:&error];
    if(error) {
        if([self.delegate respondsToSelector:@selector(pageLoaded:withError:)]) {
            [self.delegate pageLoaded:nil withError:error];
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
                [self notifyUI:playItem];
            }
        }//end of for
    }
    
    HTMLNode *moreNode = [body findChildWithAttribute:@"class" matchingName:@"link-showMore" allowPartial:YES];
    if([self.delegate respondsToSelector:@selector(pageLoaded:withError:)]) {
        [self.delegate pageLoaded:[moreNode getAttributeNamed:@"data-ajax-url"] withError:error];
    }
}
//找到一部动画，存储到DB后更新UI
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
        
        //[self.delegate playItemFound:playItem];
    }
}
@end
