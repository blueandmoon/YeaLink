//
//  UIColor+Utils.m
//  YeaLink
//
//  Created by 李根 on 16/4/25.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    return [UIColor colorWithHex:hexValue alpha:1.0];
}
@end
