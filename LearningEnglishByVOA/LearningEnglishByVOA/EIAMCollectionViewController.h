//
//  EIAMCollectionViewController.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EIAMDataSource.h"
#import "EIAMCollectionViewCell.h"
#import "PlayItem.h"
#import "TrackItem.h"

//English In A Minute
@interface EIAMCollectionViewController : UICollectionViewController<EIAMDataSourceDelegate, EIAMCollectionViewCellDelegate, UICollectionViewDelegateFlowLayout>

@end
