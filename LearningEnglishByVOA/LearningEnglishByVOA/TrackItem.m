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
+ (NSString *)primaryKey {
    return @"dataSrc";
}

+ (NSArray *)indexedProperties {
    return @[@"dataInfo"];
}

+ (NSArray *)ignoredProperties {
    return @[@"downloaded"];
}

-(BOOL) hasDownloaded {
    NSString *path = [PathUtil englishInAMinutePath];
    NSString *fileName = [self.dataSrc lastPathComponent];
    if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:fileName]]) {
        return YES;
    }
    return NO;
}

-(NSURLSessionDownloadTask *) fetchTrackToPath:(NSString *) path withProgress:(DataDownloadProgressBlock) progress complete:(DataCompletionBlock) completion {
    
    NSString *fileName = [self.dataSrc lastPathComponent];
    return [[VideoUtil sharedInstance] fetchVideo:self.dataSrc
                                     toFile:[path stringByAppendingPathComponent:fileName]
                                   progress:^(int64_t totalBytes, int64_t downloadedBytes) {
                                       if(progress) {
                                           main_queue(progress(totalBytes, downloadedBytes));
                                       }
                                   }
                                 completion:^(NSData * _Nullable content, NSError * _Nullable error) {
                                     if(completion) completion(nil, error);
                                 }];
    
}

-(NSString *) description {
    return [NSMutableString stringWithFormat: @"%@\ndataInfo:%@\ndataSrc:%@",
                             _dataType,
                             _dataInfo,
                             _dataSrc];
}

@end
