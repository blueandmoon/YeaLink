//
//  AccessControlView.h
//  YeaLink
//
//  Created by 李根 on 16/6/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
#import "DragButton.h"
#import "SlideButton.h"
#import "VisitorView.h"
#import "DropDownListView.h"

/**
 *  门禁开门
 */
@interface AccessControlView : QJLBaseView
@property(nonatomic, strong)QJLBaseTextfield *addressField; //  地址栏
@property(nonatomic, strong)SlideButton *videoBtn;    //  视频开锁按钮
@property(nonatomic, strong)SlideButton *blueToothBtn;    //  蓝牙开锁按钮
@property(nonatomic, strong)SlideButton *passwordBtn; //  密码授权按钮
@property(nonatomic, strong)QJLBaseView *coverView; //  遮蔽视图
@property(nonatomic, strong)DropDownListView *dropView; //  地址栏点击下拉
@property(nonatomic, strong)UIView *view;   //  覆盖视图

@property(nonatomic, strong)void(^clickAddress)();  //  点击地址栏, 出现下拉

@end
