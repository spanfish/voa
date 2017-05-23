//
//  PathUtil.m
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 5/10/17.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "PathUtil.h"
#import "Common.h"

@implementation PathUtil

+(NSString *) pathForType:(TargetType) targetType {
    NSString *folder = nil;
    switch (targetType) {
        case TARGET_MINUTE:
            folder = @"englishInAMinitue";
            break;
        case TARGET_MOVIE:
            folder = @"englishInMovie";
            break;
        case TARGET_GRAMMAR:
            folder = @"grammar";
            break;
        case TARGET_ENGLISH_TV:
            folder = @"TV";
            break;
        case TARGET_LEARN_ENGLISH:
            folder = @"learnEnglish";
            break;
        case TARGET_NEW_WORDS:
            folder = @"newWords";
            break;
        case TARGET_PEOPLE:
            folder = @"people";
            break;
        default:
            break;
    }
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:folder];
    
    return path;
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
