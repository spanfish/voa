//
//  AppDelegate.m
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 5/7/17.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "PathUtil.h"
#import "MenuTableViewController.h"
#import "IAPManager.h"
#import "RealmDatabase.h"

@interface AppDelegate () {
    NSMutableDictionary *_downloadDict;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _downloadDict = [NSMutableDictionary dictionary];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [PathUtil englishInAMinutePath];
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    }
    
    path = [PathUtil englishInMoviePath];
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
    }
    
    //call intensionaly to insure there is a instance of IAPManager
    //[[IAPManager sharedInstance] loadPurchasedProducts];
    
    [RealmDatabase setup];
    
    self.playList = [NSMutableArray array];
    
    // Allow the app sound to continue to play when the screen is locked.
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) { /* handle the error condition */ }
    return YES;
}

-(void) addDownloadTask:(NSURLSessionDownloadTask*) task forKey:(NSString *) key {
    [_downloadDict setObject:task forKey:key];
}

-(void) removeDownloadTaskForKey:(NSString *) key {
    [_downloadDict removeObjectForKey:key];
}

-(NSUInteger) numberOfDownloadTask {
    return [_downloadDict count];
}

-(BOOL) containsDownloadTaskForKey:(NSString *) key {
    if(key == nil) {
        return NO;
    }
    return [_downloadDict objectForKey:key] != nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //Disabling the video tracks in the player item
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) addToPlayList:(PlayItem *) item {
    if(!self.playList) {
        self.playList = [NSMutableArray array];
    }
    
    [self.playList addObject:item];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}
@end
