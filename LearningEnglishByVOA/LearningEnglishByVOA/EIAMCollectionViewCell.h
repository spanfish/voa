//
//  EIAMCollectionViewCell.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EIAMCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>

@property(nonatomic, weak) IBOutlet UIImageView *thumbImageView;
@property(nonatomic, weak) IBOutlet UILabel *dateLabel;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@end
