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
//@property(nonatomic, copy) CompletionBlock completionBlock;
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
    //self.completionBlock = block;
//    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
//    [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
//    [self.sessionManager setResponseSerializer:serializer];
    
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
    NSLog(@"fetch video:%@", videoURL);
//    AFHTTPResponseSerializer *serializer = [AFCompoundResponseSerializer serializer];
//    [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"video/mp4",
//                                           @"image/jpeg",
//                                           @"image/png",
//                                           @"audio/mpeg", @"application/octet-stream", nil]];
//    [self.sessionManager setResponseSerializer:serializer];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:videoURL]];
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"totalUnitCount:%lld, completedUnitCount:%lld", downloadProgress.totalUnitCount, downloadProgress.completedUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"targetPath:%@", targetPath);
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        block(nil, error);
    }];
    [downloadTask resume];
//    self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//    
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//    
//} completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//    
//}];
//    [self.sessionManager GET:videoURL
//                  parameters:nil
//                    progress:^(NSProgress * _Nonnull downloadProgress) {
//                        
//                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                         block(responseObject, nil);
//                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                         block(nil, error);
//                     }];
}
@end
