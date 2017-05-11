//
//  Common.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/11.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define main_thread(x) if([[NSThread currentThread] isMainThread]) {\
(x);\
} else {\
dispatch_async(dispatch_get_main_queue(), ^{\
(x);\
});\
}
#endif /* Common_h */
