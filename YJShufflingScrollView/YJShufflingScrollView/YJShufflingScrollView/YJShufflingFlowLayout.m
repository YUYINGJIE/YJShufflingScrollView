//
//  YJShufflingFlowLayout.m
//  YJShufflingScrollView
//
//  Created by YJ on 2019/11/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJShufflingFlowLayout.h"

@implementation YJShufflingFlowLayout
CGFloat ActiveDistance = 400; //垂直缩放除以系数
CGFloat ScaleFactor = 0.20;

/*
 
 返回值决定了collectionView停止滚动时, 最终的偏移量
 velocity: 滚动速率, 通过这个参数可以了解到滚动方向
 
 */
- (void)prepareLayout
{
    [super prepareLayout];
    //设置内边距
    CGFloat margin = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    NSArray <UICollectionViewLayoutAttributes *>*array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width/2;
    
     CGFloat min = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * layoutAttributes in array) {
        if (ABS(min)>ABS(layoutAttributes.center.x-centerX)) {
            min=layoutAttributes.center.x-centerX;
        }
    }
    proposedContentOffset.x+=min;
    return proposedContentOffset;
}

//存储cell排布方式
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect  visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
   
    // 计算collectionView最中心点的x值 相对contentsize
  //  CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;

    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        CGFloat distance = CGRectGetMidX(visibleRect) - attrs.center.x;
        CGFloat normalizedDistance = fabs(distance / ActiveDistance);
        CGFloat zoom = 1 - ScaleFactor * normalizedDistance;
        attrs.transform3D = CATransform3DMakeScale(1.0, zoom, 5.5);
    }
    
    return array;
}
//防止报错 先复制attributes
- (NSArray *)getCopyOfAttributes:(NSArray *)attributes
{
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyArr addObject:[attribute copy]];
    }
    return copyArr;
}

/*
 如果返回YES, 那么collectionView显示的范围发生变化时, 就会重新刷新布局
 一旦刷新布局就会按顺序调用下面的方法:
 prepareLayout
 layoutAttributesForElementsInRect:
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}
//-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//}

@end
