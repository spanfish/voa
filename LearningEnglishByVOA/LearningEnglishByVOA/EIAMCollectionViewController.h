//
//  EIAMCollectionViewController.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOS_Slide_Menu/SlideNavigationController.h>

#import "EIAMDataSource.h"
#import "EIAMCollectionViewCell.h"

//English In A Minute
@interface EIAMCollectionViewController : UICollectionViewController<EIAMDataSourceDelegate, EIAMCollectionViewCellDelegate, SlideNavigationControllerDelegate>

@end
