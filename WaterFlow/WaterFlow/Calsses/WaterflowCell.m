//
//  WaterflowCell.m
//  Waterflow
//
//  Created by 李保磊 on 16/3/14.
//  Copyright © 2016年 XO. All rights reserved.
//

#import "WaterflowCell.h"
#import "Waterflow.h"

@implementation WaterflowCell

+ (instancetype)waterflowCellWithWaterflow:(Waterflow *)waterflow{

    static NSString *ID = @"waterflow";
    
    WaterflowCell *cell = [waterflow dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[WaterflowCell alloc] initWithIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithIdentifier:(NSString *)identifier{
    
    if ([super init]) {
        
        _identifier = identifier;
    }
    
    return self;
}

@end
