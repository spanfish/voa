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
    BOOL _touchBegan;
    CGSize _trackDimensions;
}
@property(nonatomic, weak) IBOutlet UIView *placeHolderView;
@property(nonatomic, weak) IBOutlet UISlider *slider;
@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic, weak) IBOutlet UIButton *stopButton;
@property(nonatomic, weak) IBOutlet UIButton *closeButton;
@property(nonatomic, weak) IBOutlet UIButton *rewindButton;
@property(nonatomic, weak) IBOutlet UIButton *forwardButton;
@property(nonatomic, weak) IBOutlet UIButton *fullscreenButton;
@property(nonatomic, weak) IBOutlet UIButton *exitFullscreenButton;
@property(nonatomic, weak) IBOutlet UILabel *playTimeLabel;
@property(nonatomic, weak) IBOutlet UILabel *remainTimeLabel;

@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) AVPlayer *player;

@property(nonatomic, assign) BOOL touchBegan;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider-thumb"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[[UIImage imageNamed:@"slider-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];

    self.exitFullscreenButton.hidden = YES;
    self.fullscreenButton.hidden = NO;
    self.playButton.hidden = YES;
    self.stopButton.hidden = YES;
    
    [self performSelector:@selector(hideControls) withObject:nil afterDelay:3.0];
}

-(void) hideControls {
    [UIView animateWithDuration:1 animations:^{
        self.placeHolderView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void) movePlayer:(UIPanGestureRecognizer *) recognizer {
    NSLog(@"translationInView:%@", NSStringFromCGPoint([recognizer translationInView:self.view]));
    NSLog(@"velocityInView:%@", NSStringFromCGPoint([recognizer velocityInView:self.view]));
}

-(void) play:(NSString *) videoPath {
    self.playTimeLabel.text = self.remainTimeLabel.text = @"00:00";
    AVAssetTrack *videoTrack = nil;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath]
                                            options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @(YES)}];
    
    NSUInteger duration = CMTimeGetSeconds([asset duration]);
    _slider.minimumValue = 0;
    _slider.maximumValue = duration;
    [self updatePlauAndPauseButton: 0];
    
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    CMFormatDescriptionRef formatDescription = NULL;
    NSArray *formatDescriptions = [videoTrack formatDescriptions];
    
    if ([formatDescriptions count] > 0)
        formatDescription = (__bridge CMFormatDescriptionRef)[formatDescriptions objectAtIndex:0];
    if ([videoTracks count] > 0)
        videoTrack = [videoTracks objectAtIndex:0];
    
    _trackDimensions = [videoTrack naturalSize];

    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    if(!_player) {
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [_player addObserver:self forKeyPath:@"rate" options:0 context:nil];
        
        __weak typeof (self) weakSelf = self;
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            if(weakSelf == nil || weakSelf.touchBegan) {
                return;
            }
            typeof (self) self = weakSelf;
            CGFloat seconds = CMTimeGetSeconds(weakSelf.player.currentTime);
            self.slider.value =  seconds;
            self.playTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)seconds/60, ((int)seconds)%60];
            
            CGFloat remain = self.slider.maximumValue - seconds;
            self.remainTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)remain/60, ((int)remain)%60];
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
        make.height.equalTo(self.view.superview.mas_width).multipliedBy(_trackDimensions.height/_trackDimensions.width);
    }];
    
    [self.view layoutIfNeeded];
    self.view.transform = CGAffineTransformIdentity;
    _playerLayer.frame = self.view.bounds;
    self.view.hidden = NO;
    [_playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"rate"]) {
        NSLog(@"self.player.rate:%f", self.player.rate);
        main_queue([self updatePlauAndPauseButton:self.player.rate]);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void) updatePlauAndPauseButton:(float) rate {
    if(rate == 0) {
        self.playButton.hidden = NO;
        self.stopButton.hidden = YES;
    } else {
        self.playButton.hidden = YES;
        self.stopButton.hidden = NO;
    }
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

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    [self showControls];
}

-(void) showControls {
    self.placeHolderView.alpha = 1;
    [VideoPlayerViewController cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideControls) withObject:nil afterDelay:3.0];
}
#pragma mark -
-(IBAction)fullscreenTouched:(id)sender {
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(winSize.height);
        make.height.mas_equalTo(winSize.width);
        make.centerX.equalTo(self.view.superview);
        make.centerY.equalTo(self.view.superview);
    }];
    [self.view layoutIfNeeded];
    
    _playerLayer.frame = CGRectMake(0, 0, winSize.height, winSize.width);
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    self.exitFullscreenButton.hidden = NO;
    self.fullscreenButton.hidden = YES;
}

-(IBAction)exitFullscreenTouched:(id)sender {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.superview);
        make.right.equalTo(self.view.superview);
        make.bottom.equalTo(self.view.superview);
        make.height.equalTo(self.view.superview.mas_width).multipliedBy(_trackDimensions.height/_trackDimensions.width);
    }];
    
    [self.view layoutIfNeeded];
    self.view.transform = CGAffineTransformIdentity;
    _playerLayer.frame = self.view.bounds;
    
    self.exitFullscreenButton.hidden = YES;
    self.fullscreenButton.hidden = NO;
}

-(IBAction)sliderValueChanged:(id)sender {
    CGFloat seekTime = self.slider.value;
    CMTimeScale timeScale = self.player.currentItem.asset.duration.timescale;
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seekTime, timeScale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}

-(IBAction)playButtonToched:(id)sender {
    [_player play];
}

-(IBAction)pauseButtonToched:(id)sender {
    [_player pause];
}

-(IBAction)closeButtonToched:(id)sender {
    [_player pause];
    self.view.hidden = YES;
}


-(IBAction)touchDown:(id)sender {
    _touchBegan = YES;
    NSLog(@"touchDown");
    
    [VideoPlayerViewController cancelPreviousPerformRequestsWithTarget:self];
}

-(IBAction)touchUp:(id)sender {
    _touchBegan = NO;
    NSLog(@"touchUp");
    
    [self performSelector:@selector(hideControls) withObject:nil afterDelay:3.0];
}

@end
