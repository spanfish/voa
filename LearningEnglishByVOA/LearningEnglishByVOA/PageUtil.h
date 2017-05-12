//
//  PageUtil.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface PageUtil : NSObject

+(instancetype _Nonnull) sharedInstance;

-(void) loadPage:(NSString * _Nonnull) pageURL completion:(CompletionBlock) block;
-(void) downloadData:(NSString *_Nonnull) videoURL completion:(DataCompletionBlock)block;
@end
