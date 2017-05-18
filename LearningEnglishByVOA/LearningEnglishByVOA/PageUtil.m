//
//  PageUtil.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "PageUtil.h"

#pragma mark - ImageUtil

@implementation ImageUtil
+(instancetype) sharedInstance {
    static ImageUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[ImageUtil alloc] init];
    });
    return util;
}

-(instancetype) init {
    self = [super init];
    if(self) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        AFImageResponseSerializer *serializer = [AFImageResponseSerializer serializer];
        [_sessionManager setResponseSerializer:serializer];
        [[_sessionManager requestSerializer] setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"
                                       forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

-(NSURLSessionDownloadTask*) fetchImage:(NSString *_Nonnull) imageURL
            toFile:(NSString * _Nonnull) filePath
          progress:(DataDownloadProgressBlock) progress
        completion:(DataCompletionBlock) complete {
    
    NSLog(@"fetchImage: %@", imageURL);
    NSLog(@"path: %@", filePath);
    NSLog(@"=========================");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"totalUnitCount:%lld, completedUnitCount:%lld", downloadProgress.totalUnitCount, downloadProgress.completedUnitCount);
        if(progress) {
            main_queue(progress(downloadProgress.totalUnitCount, downloadProgress.completedUnitCount));
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"targetPath:%@", targetPath);
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(complete) {
            complete(nil, error);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}
@end

#pragma mark - VideoUtil
@implementation VideoUtil

+(instancetype) sharedInstance {
    static VideoUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[VideoUtil alloc] init];
    });
    return util;
}

-(instancetype) init {
    self = [super init];
    if(self) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"video/mp4", @"video/mpeg", nil]];
        [_sessionManager setResponseSerializer:serializer];
        [[_sessionManager requestSerializer] setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"
                                   forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

-(NSURLSessionDownloadTask *) fetchVideo:(NSString *_Nonnull) videoURL
            toFile:(NSString * _Nonnull) filePath
          progress:(DataDownloadProgressBlock) progress
        completion:(DataCompletionBlock) complete {
    NSLog(@"fetchVideo: %@", videoURL);
    NSLog(@"path: %@", filePath);
    NSLog(@"=========================");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:videoURL]];
    NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"totalUnitCount:%lld, completedUnitCount:%lld", downloadProgress.totalUnitCount, downloadProgress.completedUnitCount);
        if(progress) {
            main_queue(progress(downloadProgress.totalUnitCount, downloadProgress.completedUnitCount));
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"targetPath:%@", targetPath);
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(complete) {
            complete(nil, error);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}
@end

#pragma mark - PageUtil

@implementation PageUtil

+(instancetype) sharedInstance {
    static PageUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[PageUtil alloc] init];
    });
    return util;
}

-(instancetype) init {
    self = [super init];
    if(self) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
        [_sessionManager setResponseSerializer:serializer];
        [[_sessionManager requestSerializer] setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"
                                       forHTTPHeaderField:@"User-Agent"];
    }
    return self;
}

-(NSURLSessionDataTask *) loadPage:(NSString *) pageURL completion:(CompletionBlock)block {
    NSAssert(pageURL != nil, @"page is nil");
    NSLog(@"URL:%@", pageURL);
    return [_sessionManager GET:pageURL
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"success");
                        NSString *htmlString = [[NSString alloc] initWithData:responseObject
                                                                     encoding:NSUTF8StringEncoding];
                        block(htmlString, nil);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"failure:%@", error);
                        block(nil, error);
                    }];
}
@end
