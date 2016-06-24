//
//  ShareButton.h
//  YeaLink
//
//  Created by 李根 on 16/6/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"

/**
 *  分享图标, 上图下字
 */
@interface ShareButton : QJLBaseView
@property(nonatomic, strong)QJLBaseButton *topBtn;
@property(nonatomic, strong)QJLBaseLabel *downLabel;

@end
