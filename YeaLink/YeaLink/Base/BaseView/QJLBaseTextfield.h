//
//  QJLBaseTextfield.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJLBaseTextfield : UITextField

- (void)createView;

+ (instancetype)textfieldCustomWithFrame:(CGRect)frame placeholderText:(NSString *)placeholderText textAlignment:(NSTextAlignment)textAlignment titlecolor:(UIColor *)titlecolor font:(UIFont *)font;

@end
