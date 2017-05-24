//
//  EIAMCollectionViewCell.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayItem.h"
#import "RMDownloadIndicator.h"

@protocol EIAMCollectionViewCellDelegate <NSObject>

-(void) downloadTouchedWithItem:(UICollectionViewCell *)cell;
-(void) playTouchedWithItem:(UICollectionViewCell *)cell;
-(void) deleteTouchedWithItem:(UICollectionViewCell *)cell;
@end

@interface EIAMCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>

@property(nonatomic, weak) IBOutlet UIImageView *thumbImageView;
@property(nonatomic, weak) IBOutlet UILabel *dateLabel;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *sizeLabel;
@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic, weak) IBOutlet UIButton *downloadButton;
@property(nonatomic, weak) IBOutlet UIButton *deleteButton;
@property(nonatomic, weak) IBOutlet RMDownloadIndicator *downloadIndicator;
@property(nonatomic, weak) id<EIAMCollectionViewCellDelegate> delegate;
//@property(nonatomic, strong) PlayItem *playItem;
@end
