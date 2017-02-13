//
//  Waterflow.h
//  Waterflow
//
//  Created by 李保磊 on 16/3/14.
//  Copyright © 2016年 XO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterflowCell.h"

typedef NS_ENUM(NSUInteger,WaterflowMarginType){
    
    WaterflowMarginTypeTop,
    WaterflowMarginTypeBottom,
    WaterflowMarginTypeLeft,
    WaterflowMarginTypeRight,
    
    WaterflowMarginTypeRow,
    WaterflowMarginTypeColumn,
};


@class Waterflow;

/**
 *  数据源
 */
@protocol  WaterflowDataSource<NSObject>

@required
/**
 *  cell的个数
 */
- (NSUInteger)numberOfCellsInWaterflow:(Waterflow *)waterflow;
- (WaterflowCell *)waterflow:(Waterflow *)waterflow cellAtIndex:(NSUInteger)index;

@optional
/**
 *  列数
 */
- (NSUInteger)numberOfColumnsInWaterflow:(Waterflow *)waterflow;

@end

/**
 *  代理方法
 */
@protocol WaterflowDelegate <UIScrollViewDelegate>

@optional
/**
 *  某一个cell的高度
 */
- (CGFloat)waterflow:(Waterflow *)waterflow heightAtIndex:(NSUInteger)index;
/**
 *  间隙
 */
- (CGFloat)waterflow:(Waterflow *)waterflow marginOfWaterflowMarginType:(WaterflowMarginType)type;
/**
 *  点击了某一个cell
 */
- (void)waterflow:(Waterflow *)waterflow didSelectCellAtIndex:(NSUInteger)index;

@end


@interface Waterflow : UIScrollView

@property (nonatomic,weak) id<WaterflowDataSource>dataSource;

@property (nonatomic,weak) id<WaterflowDelegate>delegate;


- (void)reloadData;

- (CGFloat)width;

- (WaterflowCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;





@end
