//
//  Waterflow.m
//  Waterflow
//
//  Created by 李保磊 on 16/3/14.
//  Copyright © 2016年 XO. All rights reserved.
//

#import "Waterflow.h"

#define WaterflowDefultColumns 3
#define WaterflowDefultMargin 10
#define WaterflowDefultHeight 80


@interface Waterflow()

@property (nonatomic,strong) NSMutableArray *cellFrames;

@property (nonatomic,strong) NSMutableDictionary *displayingCells;

@property (nonatomic,strong) NSMutableSet *reusableCells;

@end

@implementation Waterflow

@dynamic delegate;




- (NSMutableArray *)cellFrames{

    if (!_cellFrames) {
        
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells{
    
    if (!_displayingCells) {
        
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSMutableSet *)reusableCells{
    
    if (!_reusableCells) {
        
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self reloadData];
    
}

- (CGFloat)width{
    
    NSUInteger numberOfColumns = [self columns];
    
    CGFloat leftM = [self marginOfWaterflowMarginType:WaterflowMarginTypeLeft];
    CGFloat rightM = [self marginOfWaterflowMarginType:WaterflowMarginTypeRight];
    CGFloat rowM = [self marginOfWaterflowMarginType:WaterflowMarginTypeRow];
    
    CGFloat cellW = (self.bounds.size.width - leftM - rightM - rowM * (numberOfColumns - 1)) / numberOfColumns;
    return cellW;
}


- (void)reloadData{
    
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.displayingCells removeAllObjects];
    
    [self.cellFrames removeAllObjects];
    
    [self.reusableCells removeAllObjects];

    NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterflow:self];
    
    NSUInteger numberOfColumns = [self columns];
    
    CGFloat topM = [self marginOfWaterflowMarginType:WaterflowMarginTypeTop];
    CGFloat bottomM = [self marginOfWaterflowMarginType:WaterflowMarginTypeBottom];
    CGFloat leftM = [self marginOfWaterflowMarginType:WaterflowMarginTypeLeft];
    CGFloat rowM = [self marginOfWaterflowMarginType:WaterflowMarginTypeRow];
    CGFloat columnM = [self marginOfWaterflowMarginType:WaterflowMarginTypeColumn];
    
    CGFloat cellW = [self width];
    
    CGFloat maxYOfCells[numberOfColumns];
    
    for (int i = 0; i < numberOfColumns; i++) {
        
        maxYOfCells[i] = 0;
        
    }
    
    for (int i = 0 ; i < numberOfCells; i++) {
        
        CGFloat cellH = [self cellOfHeightAtIndex:i];
        
        NSInteger cellColumn = 0;
        
        CGFloat maxYOfCell = maxYOfCells[cellColumn];
        
        for (int i = 1; i < numberOfColumns; i++) {
            
            if (maxYOfCell > maxYOfCells[i]) {
                
                cellColumn = i;
                
                maxYOfCell = maxYOfCells[i];
            }
        }
        
        CGFloat cellX = leftM + cellColumn * (rowM + cellW);
        
        CGFloat cellY = 0.0;
        
        if (maxYOfCell == 0.0) {
            
            cellY = topM;
            
        }else{
        
            cellY = columnM + maxYOfCell;
            
        }
        
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        maxYOfCells[cellColumn] = CGRectGetMaxY(cellFrame);
        
    }
    
    CGFloat contentH = maxYOfCells[0];
    
    for (int j = 1; j < numberOfColumns; j++) {
        
        if (contentH < maxYOfCells[j]) {
            
            contentH = maxYOfCells[j];
        }
    }
    
    contentH += bottomM;
    
    self.contentSize = CGSizeMake(0, contentH);

}




-(void)layoutSubviews{

    [super layoutSubviews];
    
    NSInteger numberOfCells = self.cellFrames.count;
    
    for (int i = 0; i < numberOfCells; i++) {
        
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        
        WaterflowCell *cell = self.displayingCells[@(i)];
        
        if ([self isInScreenWithFrame:cellFrame]) {
            
            if (cell == nil) {
                
                cell = [self.dataSource waterflow:self cellAtIndex:i];
                
                cell.frame = cellFrame;
                
                self.displayingCells[@(i)] = cell;
                
                [self addSubview:cell];
                
            }
            
        }else{
        
            if (cell) {
                
                [cell removeFromSuperview];
                
                [self.displayingCells removeObjectForKey:@(i)];
                
                [self.reusableCells addObject:cell];
                
            }
        }
    }
}


- (BOOL)isInScreenWithFrame:(CGRect)frame{

    return CGRectGetMaxY(frame) > self.contentOffset.y || CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height;

}

- (CGFloat)cellOfHeightAtIndex:(NSUInteger)index{

    if ([self.delegate respondsToSelector:@selector(waterflow:heightAtIndex:)]) {
        
        return [self.delegate waterflow:self heightAtIndex:index];
        
    }else{
    
        return WaterflowDefultHeight;
    }
}


- (NSUInteger)columns{
    
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflow:)]) {
        
        return [self.dataSource numberOfColumnsInWaterflow:self];
        
    }else{
        
        return WaterflowDefultColumns;
    }
}

- (CGFloat)marginOfWaterflowMarginType:(WaterflowMarginType)type{
    
    if ([self.delegate respondsToSelector:@selector(waterflow:marginOfWaterflowMarginType:)]) {
        
        return [self.delegate waterflow:self marginOfWaterflowMarginType:type];
        
    }else{
    
        return WaterflowDefultMargin;
    
    }
}

-(WaterflowCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{

    __block WaterflowCell *reusableCell;
    
    [self.reusableCells enumerateObjectsUsingBlock:^(WaterflowCell  *cell, BOOL * _Nonnull stop) {
        
        if ([cell.identifier isEqualToString:identifier]) {
            
            reusableCell = cell;
            
            *stop = YES;
        }
        
    }];
    
    if (reusableCell) {
        
        [self.reusableCells removeObject:reusableCell];
    }
    
    return reusableCell;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *index;
    
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, WaterflowCell *cell, BOOL * _Nonnull stop) {
        
        if (CGRectContainsPoint(cell.frame, point)) {
            
            index = key;
            
            *stop = YES;
        }
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(waterflow:didSelectCellAtIndex:)]) {
        
        [self.delegate waterflow:self didSelectCellAtIndex:index.unsignedIntegerValue];
    }
    
    

}

@end
