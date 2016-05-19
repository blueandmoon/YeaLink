//
//  QJLBaseScrollVIew.h
//  YeaLink
//
//  Created by 李根 on 16/5/14.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJLBaseScrollVIew : UIScrollView

- (void)createView;

+ (instancetype)scrollViewWithFrame:(CGRect)frame ImageArr:(NSMutableArray *)arr bgColor:(UIColor *)bgcolor;

@end
