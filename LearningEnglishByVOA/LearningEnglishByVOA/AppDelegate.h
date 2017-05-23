//
//  AppDelegate.h
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 5/7/17.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "PlayItem.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) NSMutableArray *playList;

-(void) addDownloadTask:(NSURLSessionDownloadTask*) task forKey:(NSString *) key;
-(void) removeDownloadTaskForKey:(NSString *) key;
-(BOOL) containsDownloadTaskForKey:(NSString *) key;
-(NSUInteger) numberOfDownloadTask;

-(void) addToPlayList:(PlayItem *) item;
@end

