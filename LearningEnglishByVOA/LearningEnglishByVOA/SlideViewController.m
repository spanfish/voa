//
//  SlideViewController.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/11.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "SlideViewController.h"

#import "PlayerViewController.h"
#import <Masonry/Masonry.h>

@interface SlideViewController () {
    PlayerViewController *_playerViewController;
}

@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (void)setup {
    [super setup];
    
    _playerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Player"];
    [self.view addSubview:_playerViewController.view];
    
    [_playerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_playerViewController.view.superview).offset(0);
        make.bottom.equalTo(_playerViewController.view.superview).offset(0);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(300);
    }];
//    NSURL *videoURL = [NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//    playerLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:playerLayer];
    //[player play];
}
@end
