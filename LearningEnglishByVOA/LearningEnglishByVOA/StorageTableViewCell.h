//
//  StorageTableViewCell.h
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 5/20/17.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorageTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *widthRatioConstraint;
@property(nonatomic, weak) IBOutlet UILabel *freeLabel;
@end
