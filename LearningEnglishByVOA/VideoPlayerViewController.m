//
//  VideoPlayerViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/22.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <Masonry/Masonry.h>

@interface VideoPlayerViewController () {
    
}

@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) AVPlayer *player;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider-thumb"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[[UIImage imageNamed:@"slider-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePlayer:)];
    [self.view addGestureRecognizer:recognizer];
}

-(void) movePlayer:(UIPanGestureRecognizer *) recognizer {
    NSLog(@"translationInView:%@", NSStringFromCGPoint([recognizer translationInView:self.view]));
    NSLog(@"velocityInView:%@", NSStringFromCGPoint([recognizer velocityInView:self.view]));
}

-(void) play:(NSString *) videoPath {
    AVAssetTrack *videoTrack = nil;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath]
                                            options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @(YES)}];
    
    NSUInteger duration = CMTimeGetSeconds([asset duration]);
    _slider.minimumValue = 0;
    _slider.maximumValue = duration;
    
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
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    if(!_player) {
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        __weak typeof (self) weakSelf = self;
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            if(weakSelf == nil) {
                return;
            }
            typeof (self) self = weakSelf;
            self.slider.value =  CMTimeGetSeconds(weakSelf.player.currentTime);
        }];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.zPosition = -1;
        [self.view.layer addSublayer:_playerLayer];
    } else {
        [_player replaceCurrentItemWithPlayerItem:playerItem];
    }
    
    [_player play];
    
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.superview);
        make.right.equalTo(self.view.superview);
        make.bottom.equalTo(self.view.superview);
        make.height.equalTo(self.view.superview.mas_width).multipliedBy(trackDimensions.height/trackDimensions.width);
    }];
    
    [self.view layoutIfNeeded];
    _playerLayer.frame = self.view.bounds;
    
    [_playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)fullscreenTouched:(id)sender {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.superview);
        make.right.equalTo(self.view.superview);
        make.bottom.equalTo(self.view.superview);
        make.top.equalTo(self.view.superview);
    }];
    
    [UIView animateWithDuration:1
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                     }];
    
}
@end
