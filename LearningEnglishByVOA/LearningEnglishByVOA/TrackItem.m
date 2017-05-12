//
//  TrackItem.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/08.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "TrackItem.h"
#import "PageUtil.h"
#import "PathUtil.h"
#import <ObjectiveCHMTLParser/HTMLNode.h>
#import <ObjectiveCHMTLParser/HTMLParser.h>
#import <JSONKit/JSONKit.h>

@implementation TrackItem

-(BOOL) hasDownloaded {
    NSString *path = [PathUtil englishInAMinutePath];
    NSString *fileName = [self.dataSrc lastPathComponent];
    if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:fileName]]) {
        return YES;
    }
    return NO;
}

-(void) fetchTrackWithComplete:(DataCompletionBlock) completion {
    [[PageUtil sharedInstance] downloadData:[PathUtil urlAppendToBase:self.dataSrc]
                                 completion:^(NSData * _Nullable content, NSError * _Nullable error) {
                                     if(error) {
                                         completion(nil, error);
                                     } else if(content != nil) {
                                         NSString *fileName = [self.dataSrc lastPathComponent];
                                         NSString *englishInAMinitueCacheDir = [PathUtil englishInAMinutePath];
                                         [content writeToFile:[englishInAMinitueCacheDir stringByAppendingPathComponent:fileName] atomically:YES];
                                         completion(nil, nil);
                                     }
                                 }];
}

-(NSString *) description {
    return [NSMutableString stringWithFormat: @"dataType:%@\ndataInfo:%@\ndataSrc:%@",
                             _dataType,
                             _dataInfo,
                             _dataSrc];
}

@end
