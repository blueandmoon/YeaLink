//
//  BaseWebViewController.h
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"

//  然而好像没有用上
typedef NS_ENUM(NSUInteger, TypeIdentity) {
    photo,
    sendshowword,
    SendMyShow,
    HeadImg,
    Maintance,
};

typedef void (^BLOCK)();

//@protocol TakeTypeDelegate <NSObject>
//
//- (void)takeTypeWith:(NSString *)type;
//
//@end

@interface BaseWebViewController : QJLBaseViewController
//@property(nonatomic, assign)id<TakeTypeDelegate>typeDelegate;   //  传类型的代理
@property(nonatomic, strong)UIWebView *wv;
@property(nonatomic, strong)BLOCK back;    //  执行返回操作
@property(nonatomic, strong)void(^takeStr)(NSString *); //  获取当前web页面的标题并传递到相应的页面
@property(nonatomic, strong)void(^backforH5)(UIWebView *);  //  执行webview页面的返回操作
@property(nonatomic, strong)BLOCK backNative;   //  返回native页面
@property(nonatomic, strong)void(^changeShowLeftButton)(NSString *); //  改变展示的左按钮, show代表秀场, find代码发现, news代表消息的主页面
@property(nonatomic, strong)void(^refreshDataWhenchangeCell)(); //  当业主把绑定的小区都删了, 变成个人用户时
@property(nonatomic, strong)UserLocation *userloc;  //  定位
@property(nonatomic, strong)void(^takeUserLocation)();  //  给js传递用户位置
@property(nonatomic, strong)void(^share)(); //  分享

- (void)getHtmlWithstr:(NSString *)str;

- (void)getHtmlWithTotalStr:(NSString *)totalStr;

@end
