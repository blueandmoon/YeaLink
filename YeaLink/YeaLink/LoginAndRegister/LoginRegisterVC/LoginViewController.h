//
//  LoginViewController.h
//  YeaLink
//
//  Created by 李根 on 16/4/28.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"

@interface LoginViewController : QJLBaseViewController
@property(nonatomic, strong)void(^afterLoginSuccessToGetHomepageData)();    //  登录成功则请求首页数据, 切换账号

@end
