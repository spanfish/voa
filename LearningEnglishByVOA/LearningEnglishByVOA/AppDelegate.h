//
//  AppDelegate.h
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 5/7/17.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayItem.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) NSMutableArray *playList;

-(void) addToPlayList:(PlayItem *) item;
@end

