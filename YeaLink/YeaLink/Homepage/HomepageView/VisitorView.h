//
//  VisitorView.h
//  YeaLink
//
//  Created by 李根 on 16/6/8.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
#import <UIKit/UIKit.h>
#import "SelectTextfield.h"
#import "ShareButton.h"

/**
 *  访客密码
 */
@interface VisitorView : QJLBaseView
@property(nonatomic, strong)SelectTextfield *addressField; //  地址
@property(nonatomic, strong)UIView *coverAddressView;
@property(nonatomic, strong)QJLBaseTextfield *entranceField;    //  门禁
@property(nonatomic, strong)UIView *coverEntranceView;
@property(nonatomic, strong)QJLBaseLabel *randomLabel; //  随机密码框
@property(nonatomic,strong)void(^removeView)(); //  移除视图
@property(nonatomic, strong)void(^selectVillage)(); //  选择楼栋房间号

//  分享
@property(nonatomic, strong)ShareButton *wechatBtn;
@property(nonatomic, strong)ShareButton *qqBtn;
@property(nonatomic, strong)ShareButton *smsBtn;

@end
