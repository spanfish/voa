//
//  PlayerViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/12.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController () {
    AVPlayerLayer *_playerLayer;
    AVPlayer *_player;
}

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    _player = [AVPlayer playerWithURL:videoURL];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_playerLayer];
    [_player play];
}

-(void) viewDidLayoutSubviews {
    _playerLayer.frame = self.view.bounds;
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

@end
