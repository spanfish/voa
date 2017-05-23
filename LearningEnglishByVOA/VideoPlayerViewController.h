//
//  VideoPlayerViewController.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/22.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayItem.h"

@protocol VideoPlayerViewControllerDelegate <NSObject>


@end

@interface VideoPlayerViewController : UIViewController

-(void) play:(NSString *) videoPath;
@property(nonatomic, weak) id<VideoPlayerViewControllerDelegate> delegate;
@end
