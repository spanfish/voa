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
    TargetType _targetType;
}
@end

@implementation EIAMDataSource

-(instancetype) initWithTargetType:(TargetType) type {
    self = [super init];
    if(self) {
        _targetType = type;
        _playItems = [[PlayItem objectsWhere:[NSString stringWithFormat:@"targetType=%ld", _targetType]] sortedResultsUsingKeyPath:@"sortedDate" ascending:NO];
    }
    return self;
}

-(void) loadInAMinuteTopPage {
    [[PageUtil sharedInstance] loadPage:[PathUtil BASE_URL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 NSAssert([[NSThread currentThread] isMainThread], @"Not main thread");
                                 NSString *topPage = nil;
                                 NSError *parseError = nil;
                                 HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&parseError];
                                 if(!parseError) {
                                     HTMLNode *body = [parser body];
                                     HTMLNode *footNode = [body findChildWithAttribute:@"id" matchingName:@"foot" allowPartial:NO];
                                     for(HTMLNode *node in [footNode findChildrenOfClass:@"handler"]) {
                                         if([node.tagName isEqualToString:@"a"]) {
                                             NSLog(@"allContents:%@", node.allContents);
                                             if([node.allContents isEqualToString:@"English in a Minute"]) {
                                                 topPage = [node getAttributeNamed:@"href"];
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 
                                 if([self.delegate respondsToSelector:@selector(topPageLoaded:withError:)]) {
                                     [self.delegate topPageLoaded:topPage withError:error != nil ? error : parseError];
                                 }
                             }];
}

-(void) loadMovieTopPage {
    [[PageUtil sharedInstance] loadPage:[PathUtil BASE_URL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 NSAssert([[NSThread currentThread] isMainThread], @"Not main thread");
                                 NSString *topPage = nil;
                                 NSError *parseError = nil;
                                 HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&parseError];
                                 if(!parseError) {
                                     HTMLNode *body = [parser body];
                                     HTMLNode *footNode = [body findChildWithAttribute:@"id" matchingName:@"foot" allowPartial:NO];
                                     for(HTMLNode *node in [footNode findChildrenOfClass:@"handler"]) {
                                         if([node.tagName isEqualToString:@"a"]) {
                                             NSLog(@"allContents:%@", node.allContents);
                                             if([node.allContents isEqualToString:@"English @ the Movies"]) {
                                                 topPage = [node getAttributeNamed:@"href"];
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 
                                 if([self.delegate respondsToSelector:@selector(topPageLoaded:withError:)]) {
                                     [self.delegate topPageLoaded:topPage withError:error != nil ? error : parseError];
                                 }
                             }];
}

-(void) loadGrammarTopPage {
    [[PageUtil sharedInstance] loadPage:[PathUtil BASE_URL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 NSAssert([[NSThread currentThread] isMainThread], @"Not main thread");
                                 NSString *topPage = nil;
                                 NSError *parseError = nil;
                                 HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&parseError];
                                 if(!parseError) {
                                     HTMLNode *body = [parser body];
                                     HTMLNode *footNode = [body findChildWithAttribute:@"id" matchingName:@"foot" allowPartial:NO];
                                     for(HTMLNode *node in [footNode findChildrenOfClass:@"handler"]) {
                                         if([node.tagName isEqualToString:@"a"]) {
                                             NSLog(@"allContents:%@", node.allContents);
                                             if([node.allContents isEqualToString:@"Everyday Grammar TV"]) {
                                                 topPage = [node getAttributeNamed:@"href"];
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 
                                 if([self.delegate respondsToSelector:@selector(topPageLoaded:withError:)]) {
                                     [self.delegate topPageLoaded:topPage withError:error != nil ? error : parseError];
                                 }
                             }];
}

-(void) loadEnglishTVTopPage {
    [[PageUtil sharedInstance] loadPage:[PathUtil BASE_URL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 NSAssert([[NSThread currentThread] isMainThread], @"Not main thread");
                                 NSString *topPage = nil;
                                 NSError *parseError = nil;
                                 HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&parseError];
                                 if(!parseError) {
                                     HTMLNode *body = [parser body];
                                     HTMLNode *footNode = [body findChildWithAttribute:@"id" matchingName:@"foot" allowPartial:NO];
                                     for(HTMLNode *node in [footNode findChildrenOfClass:@"handler"]) {
                                         if([node.tagName isEqualToString:@"a"]) {
                                             NSLog(@"allContents:%@", node.allContents);
                                             if([node.allContents isEqualToString:@"Learning English TV"]) {
                                                 topPage = [node getAttributeNamed:@"href"];
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 
                                 if([self.delegate respondsToSelector:@selector(topPageLoaded:withError:)]) {
                                     [self.delegate topPageLoaded:topPage withError:error != nil ? error : parseError];
                                 }
                             }];
}

-(void) loadLearnEnglishTopPage {
    [[PageUtil sharedInstance] loadPage:[PathUtil BASE_URL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 NSAssert([[NSThread currentThread] isMainThread], @"Not main thread");
                                 NSString *topPage = nil;
                                 NSError *parseError = nil;
                                 HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&parseError];
                                 if(!parseError) {
                                     HTMLNode *body = [parser body];
                                     HTMLNode *footNode = [body findChildWithAttribute:@"id" matchingName:@"foot" allowPartial:NO];
                                     for(HTMLNode *node in [footNode findChildrenOfClass:@"handler"]) {
                                         if([node.tagName isEqualToString:@"a"]) {
                                             NSLog(@"allContents:%@", node.allContents);
                                             if([node.allContents isEqualToString:@"Let's Learn English"]) {
                                                 topPage = [node getAttributeNamed:@"href"];
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 
                                 if([self.delegate respondsToSelector:@selector(topPageLoaded:withError:)]) {
                                     [self.delegate topPageLoaded:topPage withError:error != nil ? error : parseError];
                                 }
                             }];
}

-(void) loadNewWordsTopPage {
    [[PageUtil sharedInstance] loadPage:[PathUtil BASE_URL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 NSAssert([[NSThread currentThread] isMainThread], @"Not main thread");
                                 NSString *topPage = nil;
                                 NSError *parseError = nil;
                                 HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&parseError];
                                 if(!parseError) {
                                     HTMLNode *body = [parser body];
                                     HTMLNode *footNode = [body findChildWithAttribute:@"id" matchingName:@"foot" allowPartial:NO];
                                     for(HTMLNode *node in [footNode findChildrenOfClass:@"handler"]) {
                                         if([node.tagName isEqualToString:@"a"]) {
                                             NSLog(@"allContents:%@", node.allContents);
                                             if([node.allContents isEqualToString:@"News Words"]) {
                                                 topPage = [node getAttributeNamed:@"href"];
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 
                                 if([self.delegate respondsToSelector:@selector(topPageLoaded:withError:)]) {
                                     [self.delegate topPageLoaded:topPage withError:error != nil ? error : parseError];
                                 }
                             }];
}

-(void) loadPeopleTopPage {
    [[PageUtil sharedInstance] loadPage:[PathUtil BASE_URL]
                             completion:^(NSString * _Nullable content, NSError * _Nullable error) {
                                 NSAssert([[NSThread currentThread] isMainThread], @"Not main thread");
                                 NSString *topPage = nil;
                                 NSError *parseError = nil;
                                 HTMLParser *parser = [[HTMLParser alloc] initWithString:content error:&parseError];
                                 if(!parseError) {
                                     HTMLNode *body = [parser body];
                                     HTMLNode *footNode = [body findChildWithAttribute:@"id" matchingName:@"foot" allowPartial:NO];
                                     for(HTMLNode *node in [footNode findChildrenOfClass:@"handler"]) {
                                         if([node.tagName isEqualToString:@"a"]) {
                                             NSLog(@"allContents:%@", node.allContents);
                                             if([node.allContents isEqualToString:@"People in America"]) {
                                                 topPage = [node getAttributeNamed:@"href"];
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 
                                 if([self.delegate respondsToSelector:@selector(topPageLoaded:withError:)]) {
                                     [self.delegate topPageLoaded:topPage withError:error != nil ? error : parseError];
                                 }
                             }];
}

//取得一页动画列表
-(void) loadPage:(NSString *) moreURL {
    [[PageUtil sharedInstance] loadPage:[PathUtil urlAppendToBase: moreURL]
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
    if(itemsNode == nil) {
        itemsNode = [body findChildWithAttribute:@"id" matchingName:@"articleItems" allowPartial:NO];
    }
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
                    if(_targetType == TARGET_MINUTE && [playItem.videoTitle hasPrefix:@"English in a Minute: "]) {
                        playItem.videoTitle = [playItem.videoTitle substringFromIndex:[@"English in a Minute: " length]];
                    } else if(_targetType == TARGET_MOVIE && [playItem.videoTitle hasPrefix:@"English @ the Movies: "]) {
                        playItem.videoTitle = [playItem.videoTitle substringFromIndex:[@"English @ the Movies: " length]];
                    }
                }
                
                playItem.targetType = _targetType;
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
                NSString *monthStr = [[tmp objectAtIndex:0] uppercaseString];
                
                if([monthStr hasPrefix:@"JAN"]) {
                    month = @"01";
                } else if([monthStr hasPrefix:@"FEB"]) {
                    month = @"02";
                } else if([monthStr hasPrefix:@"MAR"]) {
                    month = @"03";
                } else if([monthStr hasPrefix:@"APR"]) {
                    month = @"04";
                } else if([monthStr hasPrefix:@"MAY"]) {
                    month = @"05";
                } else if([monthStr hasPrefix:@"JUN"]) {
                    month = @"06";
                } else if([monthStr hasPrefix:@"JUL"]) {
                    month = @"07";
                } else if([monthStr hasPrefix:@"AUG"]) {
                    month = @"08";
                } else if([monthStr hasPrefix:@"SEP"]) {
                    month = @"09";
                } else if([monthStr hasPrefix:@"OCT"]) {
                    month = @"10";
                } else if([monthStr hasPrefix:@"NOV"]) {
                    month = @"11";
                } else if([monthStr hasPrefix:@"DEC"]) {
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
