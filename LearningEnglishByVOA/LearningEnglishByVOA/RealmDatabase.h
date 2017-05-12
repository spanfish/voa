//
//  RealmDatabase.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/12.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface RealmDatabase : NSObject

+ (void)setup;

+ (RLMMigrationBlock)update;
@end
