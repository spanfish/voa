//
//  RealmDatabase.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/12.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "RealmDatabase.h"
#import "PathUtil.h"
#import "PlayItem.h"

static NSString *defaultDBName = @"voa.dat";

@implementation RealmDatabase

+ (void)setup {
    //データベースの存在チェック
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [NSURL fileURLWithPath:[[PathUtil documentDir] stringByAppendingPathComponent:defaultDBName]];
    config.readOnly = NO;
    config.schemaVersion = 3;
    config.migrationBlock = [self update];
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

+ (RLMMigrationBlock) update {
    RLMMigrationBlock block = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        [migration enumerateObjects:PlayItem.className block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
            if(oldSchemaVersion < 2) {
                newObject[@"deleted"] = [NSNumber numberWithInteger:0];
            }
            if(oldSchemaVersion < 3) {
                newObject[@"videoDownloaded"] = [NSNumber numberWithInteger:0];
            }
        }];
    };
    
    return block;
}
@end
