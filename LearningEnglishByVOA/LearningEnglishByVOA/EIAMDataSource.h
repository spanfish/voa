//
//  EIAMDataSource.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EIAMDataSourceDelegate<NSObject>

-(void) pageLoaded:(BOOL) hasMore withError:(NSError * _Nullable) error;
@end

@interface EIAMDataSource : NSObject

@property(nonatomic, weak) id<EIAMDataSourceDelegate> delegate;
@property(nonatomic, strong, readonly) NSArray *videoArray;
-(void) loadPage;
@end
