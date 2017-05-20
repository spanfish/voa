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
    //NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *englishInAMinitueCacheDir = [path stringByAppendingPathComponent:@"englishInAMinitues"];
    
    return englishInAMinitueCacheDir;
}

+(NSString *) englishInMoviePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *englishInMoviePath = [path stringByAppendingPathComponent:@"englishInMovie"];
    
    return englishInMoviePath;
}

+(NSString *) documentDir {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

+(NSString *) BASE_URL {
    return @"http://learningenglish.voanews.com";
}

+(NSString *) urlAppendToBase:(NSString *) url {
    if(url) {
        if([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            return url;
        } else {
            return [[PathUtil BASE_URL] stringByAppendingString:url];
        }
    } else {
        return [PathUtil BASE_URL];
    }
}
@end
