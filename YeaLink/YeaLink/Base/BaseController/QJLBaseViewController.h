//
//  QJLBaseViewController.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLocation.h"

@interface QJLBaseViewController : UIViewController

@property(nonatomic, strong)NSMutableArray *dataArrFirst;   //  接收网络请求数据
@property(nonatomic, strong)NSMutableArray *dataArrSecond;
@property(nonatomic,strong)NSMutableArray *dataArrThird;
@property(nonatomic, strong)BaseProgressHUD *hud; //  菊花朵朵
@property(nonatomic, strong)QJLBaseImageView *bgImageView;


- (void)getView;
- (void)getValue;
- (void)questData;  //  请求数据
- (void)newData;    //  刷新数据



@end
