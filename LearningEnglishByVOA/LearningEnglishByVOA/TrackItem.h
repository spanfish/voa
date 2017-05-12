//
//  TrackItem.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/08.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface TrackItem : NSObject
@property(nonatomic, strong) NSString *dataType;//video/mp4
@property(nonatomic, strong) NSString *dataInfo;//270p,360p,720p
@property(nonatomic, strong) NSString *dataSrc;//URL

@property(nonatomic, assign, readonly, getter=hasDownloaded) BOOL downloaded;

-(void) fetchTrackWithComplete:(DataCompletionBlock) completion;
@end
