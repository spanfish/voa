//
//  VideoPlayerViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/22.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <Masonry/Masonry.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerSlider.h"
#include <stdlib.h>
#import "PathUtil.h"

@interface VideoPlayerViewController () {
    BOOL _touchBegan;
    CGSize _trackDimensions;
    BOOL _fullscreen;
    
    RLMResults<PlayItem *> *playItems;
    TargetType _targetType;
}
@property(nonatomic, weak) IBOutlet UIView *placeHolderView;
@property(nonatomic, weak) IBOutlet PlayerSlider *slider;
@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic, weak) IBOutlet UIButton *stopButton;
@property(nonatomic, weak) IBOutlet UIButton *closeButton;
@property(nonatomic, weak) IBOutlet UIButton *rewindButton;
@property(nonatomic, weak) IBOutlet UIButton *forwardButton;
@property(nonatomic, weak) IBOutlet UIButton *fullscreenButton;
@property(nonatomic, weak) IBOutlet UIButton *exitFullscreenButton;
@property(nonatomic, weak) IBOutlet UILabel *playTimeLabel;
@property(nonatomic, weak) IBOutlet UILabel *remainTimeLabel;

@property(nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) AVPlayer *player;

@property(nonatomic, assign) BOOL touchBegan;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MPRemoteCommandCenter sharedCommandCenter].playCommand addTarget:self action:@selector(startPlay:)];
    [MPRemoteCommandCenter sharedCommandCenter].playCommand.enabled = YES;
    
    [[MPRemoteCommandCenter sharedCommandCenter].pauseCommand addTarget:self action:@selector(pause:)];
    [MPRemoteCommandCenter sharedCommandCenter].pauseCommand.enabled = YES;
    
    [[MPRemoteCommandCenter sharedCommandCenter].stopCommand addTarget:self action:@selector(stop:)];
    [MPRemoteCommandCenter sharedCommandCenter].stopCommand.enabled = YES;
    
    [[MPRemoteCommandCenter sharedCommandCenter].togglePlayPauseCommand addTarget:self action:@selector(toogle:)];
    [MPRemoteCommandCenter sharedCommandCenter].togglePlayPauseCommand.enabled = YES;
    
    [[MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand addTarget:self action:@selector(next:)];
    [MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand.enabled = YES;
    
    [[MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand addTarget:self action:@selector(previous:)];
    [MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand.enabled = YES;
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider-thumb"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[[UIImage imageNamed:@"slider-left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[[UIImage imageNamed:@"slider-maximum"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    self.exitFullscreenButton.hidden = YES;
    self.fullscreenButton.hidden = NO;
    self.playButton.hidden = YES;
    self.stopButton.hidden = YES;
    
    [self performSelector:@selector(hideControls) withObject:nil afterDelay:3.0];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//    recognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    tapRecognizer.cancelsTouchesInView = YES;
    tapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapRecognizer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerEnded:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playSuffle:)
                                                 name:@"Suffle"
                                               object:nil];
}

-(void) dealloc {
    [MPRemoteCommandCenter sharedCommandCenter].playCommand.enabled = NO;
    [MPRemoteCommandCenter sharedCommandCenter].pauseCommand.enabled = NO;
    [MPRemoteCommandCenter sharedCommandCenter].stopCommand.enabled = NO;
    [MPRemoteCommandCenter sharedCommandCenter].togglePlayPauseCommand.enabled = NO;
    [MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand.enabled = NO;
    [MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand.enabled = NO;
}

-(void) applicationWillResignActive:(NSNotification *) notification {
    NSArray *tracks = [_playerItem tracks];
    for (AVPlayerItemTrack *playerItemTrack in tracks)
    {
        // find video tracks
        if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual])
        {
            playerItemTrack.enabled = NO; // disable the track
        }
    }
    
    
}

#pragma mark - MPRemoteCommandCenter
-(void) startPlay:(id) sender {
    [self.player play];
}

-(void) pause:(id) sender {
    [self.player pause];
}

-(void) stop:(id) sender {
    [self.player pause];
}

-(void) toogle:(id) sender {
    if(self.player.rate == 0) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

-(void) next:(id) sender {
    NSLog(@"next");
}

-(void) previous:(id) sender {
    NSLog(@"previous");
}
#pragma mark -
-(void) applicationWillEnterForeground:(NSNotification *) notification {
    NSArray *tracks = [_playerItem tracks];
    for (AVPlayerItemTrack *playerItemTrack in tracks)
    {
        // find video tracks
        if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual])
        {
            playerItemTrack.enabled = YES; // enable the track
        }
    }
}

-(void) playerEnded:(NSNotification *) notification {
    NSLog(@"playerEnded");
    if(playItems == nil) {
        [self closeButtonToched:nil];
    } else {
        [self randomPlay];
    }
}

-(void) tapGesture:(UITapGestureRecognizer *)recognizer {
    CGPoint locationInSlider = [recognizer locationInView:self.placeHolderView];
    if(CGRectContainsPoint(self.slider.frame, locationInSlider)) {
        return;
    }
    if(_fullscreen) {
        [self exitFullscreenTouched:nil];
    } else {
        [self fullscreenTouched:nil];
    }
}

-(void) panGesture:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"panGesture:%@", NSStringFromCGPoint([recognizer locationInView:self.placeHolderView]));
    CGPoint locationInSlider = [recognizer locationInView:self.placeHolderView];
    if(CGRectContainsPoint(self.slider.frame, locationInSlider)) {
        return;
    }
    [VideoPlayerViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showControls) object:nil];
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat transX = ABS(translation.x);
    CGFloat transY = ABS(translation.y);
    if(transX < transY) {
        if(_fullscreen) {
            return;
        }
        //move up down
        CGPoint velocity = [recognizer velocityInView:self.view];
        NSLog(@"velocity:%@", NSStringFromCGPoint(velocity));
        if(ABS(velocity.y) < 600) {
            return;
        }
        if(velocity.y > 0) {
            //down
            [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.superview);
                make.right.equalTo(self.view.superview);
                make.bottom.equalTo(self.view.superview);
                make.height.equalTo(self.view.superview.mas_width).multipliedBy(_trackDimensions.height/_trackDimensions.width);
            }];
            
            [self.view layoutIfNeeded];
        } else {
            //up
            [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.superview);
                make.right.equalTo(self.view.superview);
                make.top.equalTo(self.view.superview);
                make.height.equalTo(self.view.superview.mas_width).multipliedBy(_trackDimensions.height/_trackDimensions.width);
            }];
            
            [self.view layoutIfNeeded];
        }
    } else {
        //move left and right
        CGPoint velocity = [recognizer velocityInView:self.view];
        NSLog(@"velocity:%@", NSStringFromCGPoint(velocity));
        if(ABS(velocity.x) < 600) {
            return;
        }
        
        if(velocity.x > 0) {
            //right
            [self forwardButtonToched: nil];
        } else {
            //left
            [self rewindButtonToched: nil];
        }
    }
}

-(void) hideControls {
    if(self.touchBegan) {
        return;
    }
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
    playItems = nil;
    [self playFile:videoPath];
}

-(void) playFile:(NSString *) videoPath {
    self.playTimeLabel.text = self.remainTimeLabel.text = @"00:00";
    AVAssetTrack *videoTrack = nil;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath]
                                            options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @(YES)}];
    
    NSUInteger duration = CMTimeGetSeconds([asset duration]);
    _slider.minimumValue = 0;
    _slider.maximumValue = duration;
    [self updatePlauAndPauseButton: 0];
    self.exitFullscreenButton.hidden = YES;
    self.fullscreenButton.hidden = NO;
    
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
    self.playerItem = playerItem;
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
    [self showControls];
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
    UITouch *touch = [touches anyObject];

    CGPoint locationInSlider = [touch locationInView:self.placeHolderView];
    if(CGRectContainsPoint(self.slider.frame, locationInSlider)) {
        return;
    }
    [self performSelector:@selector(showControls) withObject:nil afterDelay:0.3];
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
    
    
    _fullscreen = YES;
    
    if(sender) {
        self.exitFullscreenButton.hidden = NO;
        self.fullscreenButton.hidden = YES;
        
        [self showControls];
    }
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
    
    
    _fullscreen = NO;
    if(sender) {
        self.exitFullscreenButton.hidden = YES;
        self.fullscreenButton.hidden = NO;
        
        [self showControls];
    }
}


-(IBAction)playButtonToched:(id)sender {
    [_player play];
    
    [self showControls];
}

-(IBAction)pauseButtonToched:(id)sender {
    [_player pause];
    
    [self showControls];
}

-(IBAction)closeButtonToched:(id)sender {
    [_player pause];
    self.view.hidden = YES;
    [self exitFullscreenTouched:nil];
}

-(IBAction)rewindButtonToched:(id)sender {
    CGFloat seekTime = CMTimeGetSeconds(self.player.currentItem.currentTime) - 3;
    seekTime = MAX(0, seekTime);
    
    CMTimeScale timeScale = self.player.currentItem.asset.duration.timescale;
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seekTime, timeScale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
    
    if(sender) {
        [self showControls];
    }
}

-(IBAction)forwardButtonToched:(id)sender {
    CGFloat seekTime = CMTimeGetSeconds(self.player.currentItem.currentTime) + 3;
    CGFloat totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
    seekTime = MIN(totalTime, seekTime);
    
    CMTimeScale timeScale = self.player.currentItem.asset.duration.timescale;
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seekTime, timeScale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
    
    if(sender) {
        [self showControls];
    }
}

#pragma mark - UISlider
-(IBAction)sliderValueChanged:(id)sender {
    CGFloat seekTime = self.slider.value;
    CMTimeScale timeScale = self.player.currentItem.asset.duration.timescale;
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seekTime, timeScale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
    
    [self showControls];
    
}

-(IBAction)sliderTouchDown:(id)sender {
    _touchBegan = YES;
    NSLog(@"touchDown");
    
    [VideoPlayerViewController cancelPreviousPerformRequestsWithTarget:self];
}

-(IBAction)sliderTouchUp:(id)sender {
    _touchBegan = NO;
    NSLog(@"touchUp");
    
    [self performSelector:@selector(hideControls) withObject:nil afterDelay:3.0];
}

#pragma mark -
-(void) playSuffle:(NSNotification *) notification {
    _targetType = [[[notification userInfo] objectForKey:@"targetType"] integerValue];
    playItems = [[PlayItem objectsWhere:[NSString stringWithFormat:@"targetType = %ld and deleted != 1 and videoDownloaded = 1", (long)_targetType]] sortedResultsUsingKeyPath:@"sortedDate" ascending:NO];
    [self randomPlay];
}

-(void) randomPlay {
    NSUInteger i = [playItems count];
    if(i > 0) {
        
        i = arc4random_uniform((uint32_t) i);
        
        PlayItem *playItem = [playItems objectAtIndex:i];
        
        NSString *path = [PathUtil pathForType:_targetType];
    
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
            [self playFile:videoFile];
        }
    }
}
@end
