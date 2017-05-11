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
        [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",
                                               @"video/mp4",
                                               @"image/jpeg",
                                               @"image/png",
                                               @"audio/mpeg", nil]];
        [util.sessionManager setResponseSerializer:serializer];
        [[util.sessionManager requestSerializer] setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"
                                       forHTTPHeaderField:@"User-Agent"];
        
    });
    return util;
}

-(void) loadPage:(NSString *) pageURL completion:(CompletionBlock)block {
    NSAssert(pageURL != nil, @"page is nil");
    //self.completionBlock = block;

    [self.sessionManager GET:pageURL
                  parameters:nil
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSString *htmlString = [[NSString alloc] initWithData:responseObject
                                                                     encoding:NSUTF8StringEncoding];
                        main_thread(block(htmlString, nil));
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        main_thread(block(nil, error));
                    }];
}

-(void) downloadData:(NSString *) videoURL completion:(DataCompletionBlock)block {
    [self.sessionManager GET:videoURL
                  parameters:nil
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         main_thread(block(responseObject, nil));
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         main_thread(block(nil, error));
                     }];
}
@end
