//
//  CaptureViewController.h
//  YeaLink
//
//  Created by 李根 on 16/6/3.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"
#import "AGSimpleImageEditorView.h"
#import "PassImageDelegate.h"

//@protocol PassImageDelegate <NSObject>
//
//
//@end

@interface CaptureViewController : QJLBaseViewController
//@property(nonatomic, assign)id<PassImageDelegate>*delegate;
@property(nonatomic, strong)void(^afterSaveImage)();    //  选择完图片保存后
@property(nonatomic, strong)UIImage *image;


@end
