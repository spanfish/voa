//
//  PageUtil.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "PageUtil.h"
#import <AFNetworking/AFNetworking.h>

#import "Common.h"

@interface PageUtil()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation PageUtil

+(instancetype) sharedInstance {
    static PageUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[PageUtil alloc] init];
        util.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
        [util.sessionManager setResponseSerializer:serializer];
        [[util.sessionManager requestSerializer] setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"
                                       forHTTPHeaderField:@"User-Agent"];
        
    });
    return util;
}

-(void) loadPage:(NSString *) pageURL completion:(CompletionBlock)block {
    NSAssert(pageURL != nil, @"page is nil");
    [self.sessionManager GET:pageURL
                  parameters:nil
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSString *htmlString = [[NSString alloc] initWithData:responseObject
                                                                     encoding:NSUTF8StringEncoding];
                        block(htmlString, nil);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        block(nil, error);
                    }];
}

-(void) downloadData:(NSString *) videoURL toFile:(NSString *) filePath completion:(DataCompletionBlock)block {
    [self downloadData:videoURL toFile:filePath progress:nil completion:block];
}

-(void) downloadData:(NSString *_Nonnull) videoURL
              toFile:(NSString * _Nonnull) filePath
            progress:(DataDownloadProgressBlock) progress
          completion:(DataCompletionBlock)block {
    NSLog(@"fetch video:%@", videoURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:videoURL]];
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"totalUnitCount:%lld, completedUnitCount:%lld", downloadProgress.totalUnitCount, downloadProgress.completedUnitCount);
        if(progress) {
            main_queue(progress(downloadProgress.totalUnitCount, downloadProgress.completedUnitCount));
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"targetPath:%@", targetPath);
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        block(nil, error);
    }];
    [downloadTask resume];
}
@end
