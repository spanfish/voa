//
//  EIAMDataSource.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageUtil.h"
#import "PlayItem.h"
#import "TrackItem.h"
#import "PathUtil.h"

@protocol EIAMDataSourceDelegate<NSObject>

-(void) pageLoaded:(BOOL) hasMore withError:(NSError * _Nullable) error;
@end

@interface EIAMDataSource : NSObject

@property(nonatomic, weak) id<EIAMDataSourceDelegate> delegate;
@property(nonatomic, readonly) NSArray *videoArray;
-(void) loadPage;
-(void) downloadPlayItemThumb:(PlayItem *) item forIndexPath:(NSIndexPath *) indexPath;
@end
