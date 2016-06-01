//
//  VideoView.h
//  YeaLink
//
//  Created by 李根 on 16/5/28.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
#import "UISpeakerButton.h"
#import "UIMicroButton.h"


@interface VideoView : QJLBaseView
@property(nonatomic, strong)QJLBaseView *videoview; //  视频显示的视图
@property(nonatomic, strong)QJLBaseButton *photoBtn; //  拍照
@property(nonatomic, strong)UISpeakerButton *HFBtn; //  免提  hands free
@property(nonatomic, strong)UIMicroButton *speakerBtn;  //  对讲
@property(nonatomic, strong)QJLBaseButton *answerBtn;   //  接听
@property(nonatomic, strong)QJLBaseButton *dropBtn; //  挂断
@property(nonatomic, strong)QJLBaseButton *unlockBtn;   //  开锁

@property(nonatomic, strong)QJLBaseButton *coverPhotoBtn;    //  覆盖按钮和文字的button
@property(nonatomic, strong)UISpeakerButton *coverHFBtn; //  免提  hands free
@property(nonatomic, strong)UIMicroButton *coverSpeakerBtn;  //  对讲
@property(nonatomic, strong)QJLBaseButton *coverAnswerBtn;   //  接听
@property(nonatomic, strong)QJLBaseButton *coverDropBtn; //  挂断
@property(nonatomic, strong)QJLBaseButton *coverUnlockBtn;   //  开锁

@end
