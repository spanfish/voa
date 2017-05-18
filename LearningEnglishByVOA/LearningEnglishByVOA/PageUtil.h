//
//  PageUtil.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

#import "Common.h"

@interface PageUtil : NSObject {
@private
    AFHTTPSessionManager *_sessionManager;
}

+(instancetype _Nonnull) sharedInstance;

-(NSURLSessionDataTask *) loadPage:(NSString * _Nonnull) pageURL completion:(CompletionBlock) block;
@end


@interface ImageUtil : NSObject {
@private
    AFHTTPSessionManager *_sessionManager;
}

+(instancetype _Nonnull) sharedInstance;

-(NSURLSessionDownloadTask*) fetchImage:(NSString *_Nonnull) imageURL
              toFile:(NSString * _Nonnull) filePath
            progress:(DataDownloadProgressBlock) progress
          completion:(DataCompletionBlock)block;
@end

@interface VideoUtil : NSObject {
@private
    AFHTTPSessionManager *_sessionManager;
}

+(instancetype _Nonnull) sharedInstance;

-(NSURLSessionDownloadTask *) fetchVideo:(NSString *_Nonnull) videoURL
            toFile:(NSString * _Nonnull) filePath
          progress:(DataDownloadProgressBlock) progress
        completion:(DataCompletionBlock)block;
@end
