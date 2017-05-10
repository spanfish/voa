//
//  ViewController.m
//  LearningEnglishByVOA
//
//  Created by Xiangwei Wang on 5/7/17.
//  Copyright © 2017 Xiangwei Wang. All rights reserved.
//

#import "ViewController.h"
#import <ObjectiveCHMTLParser/Objective-C-HMTL-Parser.h>
#import "EIAMDataSource.h"

//http://learningenglish.voanews.com/z/3619
//English in a Minute: Wires Crossed

@interface ViewController () {
    EIAMDataSource *dataSource;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dataSource = [[EIAMDataSource alloc] init];
    [dataSource loadPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
