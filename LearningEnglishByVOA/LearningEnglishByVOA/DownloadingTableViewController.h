//
//  DownloadingTableViewController.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/23.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSLayoutConstraint+Multiplier.h"
#import "PlayerSlider.h"

@interface DownloadingTableViewController : UITableViewController

@end


@interface DownloadingTableViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet PlayerSlider *slider;
@property(nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@end
