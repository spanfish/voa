//
//  PlayItem.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/08.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "PlayItem.h"
#import "TrackItem.h"

@implementation PlayItem
-(instancetype) init {
    self = [super init];
    if(self) {
        _allTracks = [NSMutableArray array];
    }
    return self;
}

-(void) addTrack:(TrackItem *) track {
    [_allTracks addObject:track];
    [_allTracks sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TrackItem *item1 = obj1;
        TrackItem *item2 = obj2;
        
        return [item1.dataType compare:item2.dataType];
    }];
}

-(NSArray<TrackItem*> *) tracks {
    return _allTracks;
}
@end
