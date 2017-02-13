//
//  ViewController.m
//  WaterFlow
//
//  Created by Mervyn on 17/2/13.
//  Copyright © 2017年 mervyn_lbl@163.com. All rights reserved.
//

#import "ViewController.h"
#import "Waterflow.h"


@interface ViewController ()<WaterflowDataSource,WaterflowDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Waterflow *waterflow = [[Waterflow alloc] init];
    
    waterflow.dataSource = self;
    
    waterflow.delegate = self;
    
    waterflow.frame = self.view.bounds;
    
    [self.view addSubview:waterflow];
}

- (NSUInteger)numberOfCellsInWaterflow:(Waterflow *)waterflow{
    
    return 50;
}

- (WaterflowCell *)waterflow:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index{
    
    WaterflowCell *cell = [WaterflowCell waterflowCellWithWaterflow:waterflow];
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
    
}

- (CGFloat)waterflow:(Waterflow *)waterflow heightAtIndex:(NSUInteger)index{
    
    switch (index % 2) {
        case 0:return 100;
        case 1:return 120;
        default:return 80;
    }
    
}

- (CGFloat)waterflow:(Waterflow *)waterflow marginOfWaterflowMarginType:(WaterflowMarginType)type{
    
    switch (type) {
        case WaterflowMarginTypeRow:return 5;
        case WaterflowMarginTypeColumn:return 5;
            
        default:return 10;
    }
    
}

- (void)waterflow:(Waterflow *)waterflow didSelectCellAtIndex:(NSUInteger)index{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
