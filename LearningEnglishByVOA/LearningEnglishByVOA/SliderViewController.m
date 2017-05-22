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
    AVPlayerLayer *_playerLayer;
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
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
         make.edges.equalTo(self.view);
    }];
    
    //_playerController.view.hidden = YES;
    
//    UIView *view = [[UIView alloc] init];
//    [_playerController.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(view.superview);
//    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playVideo:)
                                                 name:@"Play"
                                               object:nil];

}

//-(void) tapped:(UITapGestureRecognizer *) recognizer {
//    NSLog(@"tapped");

//    [_playerController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
//        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
//        make.center.equalTo(self.view);
//    }];
//}
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
        AVAssetTrack *videoTrack = nil;
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoFile]];
        NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        CMFormatDescriptionRef formatDescription = NULL;
        NSArray *formatDescriptions = [videoTrack formatDescriptions];
        
        if ([formatDescriptions count] > 0)
            formatDescription = (__bridge CMFormatDescriptionRef)[formatDescriptions objectAtIndex:0];
        if ([videoTracks count] > 0)
            videoTrack = [videoTracks objectAtIndex:0];
        
        CGSize trackDimensions = {
            .width = 0.0,
            .height = 0.0,
        };
        trackDimensions = [videoTrack naturalSize];
        
        _playerItem = [AVPlayerItem playerItemWithAsset:asset];
        if(!_player) {
            _player = [AVPlayer playerWithPlayerItem:_playerItem];
        } else {
            [_player replaceCurrentItemWithPlayerItem:_playerItem];
        }
//        _playerController.player = _player;
//        [_player play];
        _playerController.view.hidden = NO;
        //_playerController.showsPlaybackControls = NO;
        [_playerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view).multipliedBy(0.5);
            make.height.equalTo(_playerController.view.mas_width).multipliedBy(trackDimensions.height/trackDimensions.width);
            make.bottom.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
        //_playerController.view.frame = CGRectMake(0, 0, trackDimensions.width, trackDimensions.height);
    } else {
        NSAssert(NO, @"video file not found");
    }
    
    //NSURL *url = nil;
    // Create asset to be played
    //asset = [AVAsset assetWithURL:url];
    //NSArray *assetKeys = @[@"playable", @"hasProtectedContent"];
    
    // Create a new AVPlayerItem with the asset and an
    // array of asset keys to be automatically loaded
    //AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset
    //                                  automaticallyLoadedAssetKeys:assetKeys];
    
}

@end
