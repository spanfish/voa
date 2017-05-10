//
//  PathUtil.m
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 5/10/17.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "PathUtil.h"

@implementation PathUtil

+(NSString *) englishInAMinutePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *englishInAMinitueCacheDir = [path stringByAppendingPathComponent:@"englishInAMinitues"];
    
    return englishInAMinitueCacheDir;
}
@end
