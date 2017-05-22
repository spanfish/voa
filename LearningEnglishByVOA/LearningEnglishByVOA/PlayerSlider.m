//
//  PlayerSlider.m
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 2017/05/22.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "PlayerSlider.h"

@implementation PlayerSlider


- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height/2);
}
@end
