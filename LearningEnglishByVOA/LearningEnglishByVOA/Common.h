//
//  Common.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/11.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#ifndef Common_h
#define Common_h

typedef void (^_Nullable CompletionBlock)(id _Nullable content, NSError *_Nullable error);
typedef void (^_Nullable DataCompletionBlock)(NSData *_Nullable content, NSError *_Nullable error);
typedef void (^_Nullable DataDownloadProgressBlock)(int64_t totalBytes, int64_t downloadedBytes);

#define main_queue(x) if([[NSThread currentThread] isMainThread]) {\
(x);\
} else {\
dispatch_async(dispatch_get_main_queue(), ^{\
(x);\
});\
}

#define global_queue(x) if([[NSThread currentThread] isMainThread]) {\
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{(x);});\
} else {\
    (x);\
}

typedef NS_ENUM(NSInteger, TargetType) {
    TARGET_MINUTE,
    TARGET_MOVIE,
    TARGET_GRAMMAR,
    TARGET_ENGLISH_TV,
    TARGET_LEARN_ENGLISH,
    TARGET_NEW_WORDS,
    TARGET_PEOPLE,
    TARGET_NUMS
};

static NSString* VIDEOS[] = {
    @"English in a Minute",
    @"English @ the Movies",
    @"Everyday Grammar TV",
    @"Learning English TV",
    @"Let's Learn English",
    @"News Words",
    @"People In America"};
#endif /* Common_h */
