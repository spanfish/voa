//
//  MoreCollectionViewCell.m
//  LearningEnglishByVOA
//
//  Created by xiangwei wang on 2017/05/19.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "MoreCollectionViewCell.h"

@implementation MoreCollectionViewCell

-(void) awakeFromNib {
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imageView addGestureRecognizer:recognizer];
}

-(void) imageTapped:(UITapGestureRecognizer *) recognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"More" object:nil];
}
@end
