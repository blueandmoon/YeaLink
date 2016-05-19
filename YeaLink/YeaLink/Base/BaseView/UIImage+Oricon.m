//
//  UIImage+Oricon.m
//  YeaLink
//
//  Created by 李根 on 16/5/5.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "UIImage+Oricon.h"

@implementation UIImage (Oricon)

- (instancetype)init {
    if ([super init]) {
        self = [[UIImage alloc] init];
    }
    return self;
}

- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //  size为CGSize类型, 即为所需要的图片尺寸
    [image drawAsPatternInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return scaledImage;
    
    
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return scaledImage;   //返回的就是已经改变的图片
}

@end
