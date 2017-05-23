//
//  PathUtil.h
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 5/10/17.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface PathUtil : NSObject

+(NSString *) pathForType:(TargetType) targetType;
+(NSString *) pathForThumb;
+(NSString *) documentDir;

+(NSString *) BASE_URL;
+(NSString *) urlAppendToBase:(NSString *) url;
@end
