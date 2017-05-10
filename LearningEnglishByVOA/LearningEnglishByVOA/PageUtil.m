//
//  PageUtil.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "PageUtil.h"
#import <AFNetworking/AFNetworking.h>

#define main_thread(x) if([[NSThread currentThread] isMainThread]) {\
                           (x);\
                       } else {\
                           dispatch_async(dispatch_get_main_queue(), ^{\
                               (x);\
                           });\
                       }

@interface PageUtil()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, copy) CompletionBlock completionBlock;
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
                                               @"application/pdf",
                                               @"video/mp4",
                                               @"audio/mpeg",
                                               @"application/x-pdf", nil]];
        [util.sessionManager setResponseSerializer:serializer];
        [[util.sessionManager requestSerializer] setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.87 Safari/537.36"
                                       forHTTPHeaderField:@"User-Agent"];
        
    });
    return util;
}

-(void) loadPage:(NSString *) pageURL completion:(CompletionBlock)block {
    NSAssert(pageURL != nil, @"page is nil");
    self.completionBlock = block;

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
@end
