//
//  HomepageCollectionFlowLayout.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepageCollectionFlowLayout : UICollectionViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;

@end
