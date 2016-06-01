//
//  UIColor+HexColor.h
//  YeaLink
//
//  Created by 李根 on 16/5/25.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;

@end
