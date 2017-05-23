//
//  DownloadingTableViewController.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/23.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadingTableViewController : UITableViewController

@end


@interface DownloadingTableViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *widthRatioConstraint;
@end
