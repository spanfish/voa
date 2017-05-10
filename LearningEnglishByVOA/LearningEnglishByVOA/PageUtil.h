//
//  PageUtil.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^_Nullable CompletionBlock)(NSString *_Nullable content, NSError *_Nullable error);
typedef void (^_Nullable DataCompletionBlock)(NSData *_Nullable content, NSError *_Nullable error);

@interface PageUtil : NSObject

+(instancetype) sharedInstance;

-(void) loadPage:(NSString *) pageURL completion:(CompletionBlock) block;
-(void) downloadVideoFile:(NSString *) videoURL completion:(DataCompletionBlock)block;
@end
