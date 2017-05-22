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

-(void) topPageLoaded:(NSString *) topPage withError:(NSError *) error;
-(void) pageLoaded:(NSString *) moreURL withError:(NSError *) error;

@end

@interface EIAMDataSource : NSObject

@property(nonatomic, weak) id<EIAMDataSourceDelegate> delegate;
@property(nonatomic, strong) RLMResults<PlayItem *> *playItems;
-(void) loadPage:(NSString *) moreURL;
-(void) loadInAMinuteTopPage;
-(void) loadMovieTopPage;
-(void) loadGrammarTopPage;
-(void) loadEnglishTVTopPage;
-(void) loadLearnEnglishTopPage;
-(void) loadNewWordsTopPage;
-(void) loadPeopleTopPage;

-(instancetype) initWithTargetType:(TargetType) type;
@end
