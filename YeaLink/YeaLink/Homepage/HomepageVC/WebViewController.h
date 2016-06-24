//
//  WebViewController.h
//  YeaLink
//
//  Created by 李根 on 16/5/5.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"

@interface WebViewController : BaseWebViewController
@property(nonatomic, strong)NSString *strURL;


- (void)createWebviewWithURL:(NSString *)strURL;

@end
