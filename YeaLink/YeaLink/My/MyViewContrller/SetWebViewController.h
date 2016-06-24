//
//  SetWebViewController.h
//  YeaLink
//
//  Created by 李根 on 16/5/14.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseWebViewController.h"
/**
 *  点击个人中心的cell跳转的页面webview
 */
@interface SetWebViewController : BaseWebViewController
@property(nonatomic, strong)void(^refreshDataPerson)();

@end
