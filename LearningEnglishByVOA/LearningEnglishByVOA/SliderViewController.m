//
//  SliderViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/19.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "SliderViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayItem.h"
#import <Masonry/Masonry.h>
#import "VideoPlayerViewController.h"

@interface SliderViewController () {
    VideoPlayerViewController *_playerController;
}
@end

@implementation SliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playerController = [[VideoPlayerViewController alloc] init];
    
    [self.view addSubview:_playerController.view];
    [self addChildViewController:_playerController];
    [_playerController didMoveToParentViewController:self];

    [_playerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playerController.view.superview);
        make.right.equalTo(_playerController.view.superview);
        make.bottom.equalTo(_playerController.view.superview);
        make.top.equalTo(_playerController.view.superview);
    }];

    _playerController.view.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playVideo:)
                                                 name:@"Play"
                                               object:nil];

}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //NSLog(@"segue.identifier:%@", segue.identifier);
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void) playVideo:(NSNotification *) notification {
    PlayItem *playItem = [[notification userInfo] objectForKey:@"playItem"];
    NSString *path = [[notification userInfo] objectForKey:@"path"];
    
    //TrackItem *playTrack = nil;
    NSString *videoFile = nil;
    //从动画列表的最后（分辨率最高）开始找，如果找到动画文件，就直接播放
    for(NSInteger i = [playItem.tracks count] - 1; i >= 0; i--) {
        TrackItem *track = [playItem.tracks objectAtIndex:i];
        NSString *fileName = [track.dataSrc lastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:fileName] isDirectory:NULL]) {
            //playTrack = track;
            videoFile = [path stringByAppendingPathComponent:fileName];
            break;
        }
    }
    
    if(videoFile != nil) {
        //找到动画文件
        [_playerController play:videoFile];
        _playerController.view.hidden = NO;
    } else {
        NSAssert(NO, @"video file not found");
    }
    
}

@end
