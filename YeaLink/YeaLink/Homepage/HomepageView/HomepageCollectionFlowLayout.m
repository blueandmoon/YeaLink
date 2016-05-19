//
//  HomepageCollectionFlowLayout.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "HomepageCollectionFlowLayout.h"

@implementation HomepageCollectionFlowLayout
/**
 *  解决collectionView中每一行的Cell之间间距与设置不相符的问题, 把其间距设为零
 *
 *  @param rect
 *
 *  @return 
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    //  打印cell的frame
//    for (UICollectionViewLayoutAttributes *attr in attributes) {
//        NSLog(@"%@", NSStringFromCGRect([attr frame]));
//    }
    
    /**
     *  从第二个循环到最后一个
     */
    for (NSInteger i = 1; i < [attributes count]; ++i) {
        //  当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //  上一个attributes
        UICollectionViewLayoutAttributes *previousLayoutAttributes = attributes[i - 1];
        //  我们想要设置的最大间距, 可根据需要改
        NSInteger maximumSpacing = 0;
        //  前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(previousLayoutAttributes.frame);
        //  如果当前一个Cell的最右边加上我们想要的间距加上当前Cell的宽度依然在contentSize中, 我们改
        //  如果不加这个判断的后果是, UIcollectionVIew只显示一行, 原因是下面所有Cell的x值都被加到第一行
        if (origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    
    
    return attributes;
}


@end
