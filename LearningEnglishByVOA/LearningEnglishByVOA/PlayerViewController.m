//
//  PlayerViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/12.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "PlayerViewController.h"


@interface PlayerViewController () {
//    AVPlayerLayer *_playerLayer;
//    AVPlayer *_player;
//    AVPlayerItem *_playerItem;
}

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playVideo:)
                                                 name:@"Play"
                                               object:nil];
    //NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    //_player = [AVPlayer playerWithURL:videoURL];
    //_playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    //_playerLayer.frame = self.view.bounds;
    //[self.view.layer addSublayer:_playerLayer];
    //[_player play];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewDidLayoutSubviews {
   // _playerLayer.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) playVideo:(NSNotification *) notification {
    //PlayItem *playItem = [[notification userInfo] objectForKey:@"playItem"];
    
    //NSURL *url = nil;
    // Create asset to be played
    //asset = [AVAsset assetWithURL:url];
    //NSArray *assetKeys = @[@"playable", @"hasProtectedContent"];
    
    // Create a new AVPlayerItem with the asset and an
    // array of asset keys to be automatically loaded
    //AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset
    //                                  automaticallyLoadedAssetKeys:assetKeys];

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
