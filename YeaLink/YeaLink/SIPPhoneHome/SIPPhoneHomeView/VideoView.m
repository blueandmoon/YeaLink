//
//  VideoView.m
//  YeaLink
//
//  Created by 李根 on 16/5/28.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "VideoView.h"

#define BGCOlor [UIColor colorWithHex:0xffffff] //  背景颜色
#define STEXTCOLOR [UIColor colorWithHex:0x666666]   //  小文字颜色
#define LTEXTCOLOR [UIColor colorWithHex:0x333333]   // 大文字颜色
#define SEPERATORLINECOLOR [UIColor colorWithHex:0xf4f4f4]   // 分割线颜色
#define SFONT [UIFont systemFontOfSize:15]  //  小字体
#define LFONT [UIFont systemFontOfSize:21]  //  大字体

@implementation VideoView
{
    QJLBaseView *_firstView;    //  底层视图
    QJLBaseLabel *_screenShotLabel; //  截图label
    QJLBaseLabel *_speakerLabel;    //  话筒
    QJLBaseLabel *_HFLabel; //  听筒
    QJLBaseView *_leftSeperatorline;   //  左分割线
    QJLBaseView *_rightSeperatorline;   //  右分割线
    
    QJLBaseView *_secondView;   //
    QJLBaseLabel *_answerLabel;  //  接听
    QJLBaseLabel *_dropLabel;   //  挂断
    QJLBaseView *_centerSeperatorline;  //  中分割线
    
    QJLBaseView *_thirdView; //
    QJLBaseLabel *_unlockLabel; //  开锁
}
- (void)createView {
    _videoview = [[QJLBaseView alloc] init];
    [self addSubview:_videoview];
    [_videoview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(21 * HEI);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(WIDTH * 3 / 4);
    }];
    
    _firstView = [[QJLBaseView alloc] init];
    [self addSubview:_firstView];
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.centerX.equalTo(self);
        make.top.equalTo(_videoview.mas_bottom).with.offset(10 * HEI);
        make.height.mas_equalTo(75 * HEI);
    }];
    
    _secondView = [[QJLBaseView alloc] init];
    [self addSubview:_secondView];
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_firstView);
        make.centerY.equalTo(_firstView).with.offset(85 * HEI);
    }];
    
    _thirdView = [[QJLBaseView alloc] init];
    [self addSubview:_thirdView];
    [_thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_firstView);
        make.centerY.equalTo(_secondView).with.offset(85 * HEI);
    }];

    //  话筒
    _speakerBtn = [UIMicroButton buttonWithType:UIButtonTypeCustom];
    [_firstView addSubview:_speakerBtn];
    [_speakerBtn setSelected:NO];
    [_speakerBtn setImage:[UIImage imageNamed:@"mic_in"] forState:UIControlStateNormal];
    [_speakerBtn setImage:[UIImage imageNamed:@"mic_out"] forState:UIControlStateSelected];
    [_firstView addSubview:_speakerBtn];
    [_speakerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(41 * WID, 41 * HEI));
        make.centerX.equalTo(_firstView);
        make.top.equalTo(_firstView).with.offset(8.5 * HEI);
    }];
    
    //  截图
    _photoBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@"screenShot"];
    [_firstView addSubview:_photoBtn];
    _photoBtn.backgroundColor = BGCOlor;
    [_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerY.equalTo(_speakerBtn);
        make.centerX.equalTo(_speakerBtn).with.offset(-WIDTH / 3);
    }];
    
    _screenShotLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"截图" titleColor:STEXTCOLOR textAlignment:NSTextAlignmentCenter font:SFONT];
    [_firstView addSubview:_screenShotLabel];
    [_screenShotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.equalTo(_photoBtn);
        make.top.equalTo(_photoBtn.mas_bottom).with.offset(5 * HEI);
        make.height.mas_equalTo(15 * HEI);
    }];
    
    _speakerLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"话筒" titleColor:STEXTCOLOR textAlignment:NSTextAlignmentCenter font:SFONT];
    [_firstView addSubview:_speakerLabel];
    [_speakerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerY.equalTo(_screenShotLabel);
        make.centerX.equalTo(_speakerBtn);
    }];
    
    //  免提
    _HFBtn = [UISpeakerButton buttonWithType:UIButtonTypeCustom];
    [_firstView addSubview:_HFBtn];
    [_HFBtn setSelected:NO];
    [_HFBtn setImage:[UIImage imageNamed:@"speaker_out"] forState:UIControlStateNormal];
    [_HFBtn setImage:[UIImage imageNamed:@"speaker_in"] forState:UIControlStateSelected];
    [_HFBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_photoBtn);
        make.centerX.equalTo(_speakerBtn).with.offset(WIDTH / 3);
        make.centerY.equalTo(_photoBtn);
    }];
    
    _HFLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"听筒" titleColor:STEXTCOLOR textAlignment:NSTextAlignmentCenter font:SFONT];
    [_firstView addSubview:_HFLabel];
    [_HFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerY.equalTo(_screenShotLabel);
        make.centerX.equalTo(_HFBtn);
    }];
    
    //  接听
    _answerBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@"answer"];
    [_secondView addSubview:_answerBtn];
//    _answerBtn.backgroundColor = [UIColor grayColor];
    [_answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21 * WID, 21 * HEI));
        make.width.mas_equalTo(21 * WID);
        make.left.equalTo(_secondView).with.offset(42.5 * WID);
//        make.top.equalTo(_secondView).with.offset(27 * HEI);
        make.centerY.equalTo(_secondView);
    }];
    
    _answerLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"接听" titleColor:LTEXTCOLOR textAlignment:NSTextAlignmentCenter font:LFONT];
    [_secondView addSubview:_answerLabel];
//    _answerLabel.backgroundColor = [UIColor grayColor];
    [_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.equalTo(_answerBtn);
        make.height.mas_equalTo(30 * HEI);
        make.width.mas_equalTo(50 * WID);
        make.left.equalTo(_answerBtn.mas_right).with.offset(10 * WID);
    }];
    
    //  挂断
    _dropBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@"drop"];
    [_secondView addSubview:_dropBtn];
    [_dropBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27 * WID, 11.5 * HEI));
        make.centerY.equalTo(_answerBtn);
        make.centerX.equalTo(_answerBtn).with.offset(WIDTH / 2);
    }];
    
    _dropLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"挂断" titleColor:LTEXTCOLOR textAlignment:NSTextAlignmentCenter font:LFONT];
    [_secondView addSubview:_dropLabel];
    [_dropLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerY.equalTo(_answerLabel);
        make.left.equalTo(_dropBtn.mas_right).with.offset(10 * WID);
    }];
    
    //  解锁
    _unlockBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@"unlock"];
    [_thirdView addSubview:_unlockBtn];
    [_unlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16 * WID, 21 * HEI));
        make.left.equalTo(_thirdView).with.offset(127.5 * WID);
        make.centerY.equalTo(_thirdView);
    }];
    
    _unlockLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"开锁" titleColor:LTEXTCOLOR textAlignment:NSTextAlignmentCenter font:LFONT];
    [_thirdView addSubview:_unlockLabel];
    [_unlockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_unlockBtn.mas_right).with.offset(10 * WID);
        make.size.equalTo(_answerLabel);
        make.centerY.equalTo(_unlockBtn);
    }];
    
    //  分割线
    _leftSeperatorline = [[QJLBaseView alloc] init];
    [_firstView addSubview:_leftSeperatorline];
    _leftSeperatorline.layer.borderWidth = 1;
    _leftSeperatorline.layer.borderColor = SEPERATORLINECOLOR.CGColor;
    [_leftSeperatorline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.centerY.equalTo(_firstView);
        make.left.equalTo(_firstView).with.offset(WIDTH / 3);
        make.width.mas_equalTo(0.5 * WID);
    }];
    
    _rightSeperatorline = [[QJLBaseView alloc] init];
    [_firstView addSubview:_rightSeperatorline];
    _rightSeperatorline.layer.borderWidth = 1;
    _rightSeperatorline.layer.borderColor = SEPERATORLINECOLOR.CGColor;
    [_rightSeperatorline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerY.equalTo(_leftSeperatorline);
        make.left.equalTo(_firstView).with.offset(WIDTH / 3 * 2);
    }];
    
    _centerSeperatorline = [[QJLBaseView alloc] init];
    [_secondView addSubview:_centerSeperatorline];
    _centerSeperatorline.layer.borderWidth = 1;
    _centerSeperatorline.layer.borderColor = SEPERATORLINECOLOR.CGColor;
    [_centerSeperatorline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_leftSeperatorline);
        make.centerY.equalTo(_secondView);
        make.left.equalTo(_secondView).with.offset(WIDTH / 2);
//        make.width.mas_equalTo(0.5 * WID);
    }];
    
#pragma mark    - 覆盖视图
//    _coverPhotoBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@""];
//    [_firstView addSubview:_coverPhotoBtn];
//    [_coverPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_photoBtn.mas_left);
//        make.right.equalTo(_photoBtn.mas_right);
//        make.top.equalTo(_photoBtn.mas_top);
//        make.bottom.equalTo(_screenShotLabel.mas_bottom);
//    }];
//    
//    _coverSpeakerBtn = [UIMicroButton buttonWithType:UIButtonTypeCustom];
//    [_firstView addSubview:_coverSpeakerBtn];
//    [_coverSpeakerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(_coverPhotoBtn);
//        make.left.equalTo(_speakerBtn.mas_left);
//        make.top.equalTo(_speakerBtn.mas_top);
//    }];
//
//    _coverHFBtn = [UISpeakerButton buttonWithType:UIButtonTypeCustom];
//    [_firstView addSubview:_coverHFBtn];
//    _coverHFBtn.backgroundColor = [UIColor redColor];
//    [_coverHFBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(_coverPhotoBtn);
//        make.left.equalTo(_HFBtn.mas_left);
//        make.top.equalTo(_HFBtn.mas_top);
//    }];
    
    _coverAnswerBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@""];
    [_secondView addSubview:_coverAnswerBtn];
    [_coverAnswerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_answerBtn.mas_left);
        make.top.and.right.and.bottom.equalTo(_answerLabel);
    }];
    
    _coverDropBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@""];
    [_secondView addSubview:_coverDropBtn];
    [_coverDropBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dropBtn.mas_left);
        make.top.and.right.and.bottom.equalTo(_dropLabel);
    }];
    
    _coverUnlockBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@""];
    [_thirdView addSubview:_coverUnlockBtn];
    [_coverUnlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_unlockBtn);
        make.top.and.right.and.bottom.equalTo(_unlockLabel);
    }];
    
}

@end
