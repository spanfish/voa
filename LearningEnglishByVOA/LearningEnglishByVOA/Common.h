//
//  Common.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/11.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#ifndef Common_h
#define Common_h

typedef void (^_Nullable CompletionBlock)(NSString *_Nullable content, NSError *_Nullable error);
typedef void (^_Nullable DataCompletionBlock)(NSData *_Nullable content, NSError *_Nullable error);


#define main_thread(x) if([[NSThread currentThread] isMainThread]) {\
(x);\
} else {\
dispatch_async(dispatch_get_main_queue(), ^{\
(x);\
});\
}
#endif /* Common_h */
