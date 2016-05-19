//
//  BaseWebViewController.h
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"

@interface BaseWebViewController : QJLBaseViewController
@property(nonatomic, strong)UIWebView *wv;
@property(nonatomic, strong)UIImageView *bgImageView;

- (void)getHtmlWithstr:(NSString *)str;

- (void)getHtmlWithTotalStr:(NSString *)totalStr;

@end
