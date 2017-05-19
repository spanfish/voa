//
//  SwitchCollectionViewCell.h
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/19.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UISwitch *switchButton;
@end
