//
//  EIAMCollectionViewCell.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/10.
//  Copyright © 2017年 Xiangwei Wang. All rights reserved.
//

#import "EIAMCollectionViewCell.h"

@implementation EIAMCollectionViewCell

-(IBAction)playButtonTouched:(id)sender {
    [self.delegate playTouchedWithItem: self];
}

-(IBAction)downloadButtonTouched:(id)sender {
    [self.delegate downloadTouchedWithItem: self];
}

-(IBAction)deleteButtonTouched:(id)sender {
    [self.delegate deleteTouchedWithItem:self];
}
@end
