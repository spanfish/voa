//
//  TrackItem.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/08.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import <Realm/Realm.h>

@interface TrackItem : RLMObject<NSURLConnectionDelegate> {
//    DataDownloadProgressBlock _progress;
//    CompletionBlock _completion;
}
@property(nonatomic, strong) NSString *dataType;//video/mp4
@property(nonatomic, strong) NSString *dataInfo;//270p,360p,720p
@property(nonatomic, strong) NSString *dataSrc;//URL

-(NSURLSessionDownloadTask *) fetchTrackToPath:(NSString *) path withProgress:(DataDownloadProgressBlock) progress complete:(DataCompletionBlock) completion;
@end

RLM_ARRAY_TYPE(TrackItem)
