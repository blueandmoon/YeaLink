//
//  QJLBaseLabel.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJLBaseLabel : UILabel

- (void)createView;

//普通的文字label
+ (instancetype)LabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                    titleColor:(UIColor *)textColor
                 textAlignment:(NSTextAlignment)textAlignment
                          font:(UIFont *)font;

@end
