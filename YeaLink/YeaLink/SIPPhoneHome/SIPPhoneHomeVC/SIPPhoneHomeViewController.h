//
//  SIPPhoneHomeViewController.h
//  YeaLink
//
//  Created by 李根 on 16/4/27.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"
#import "UISpeakerButton.h"
#import "UIMicroButton.h"


@class UIAddressTextField;
@class UIDigitButton;
@class UIEraseButton;
@class UIVideoButton;
@class UIMicroButton;
@class UISpeakerButton;

@interface SIPPhoneHomeViewController : QJLBaseViewController
@property(nonatomic, strong)QJLBaseLabel *addressLabel; //  地址栏
@property(nonatomic, strong)QJLBaseButton *photoButton; //  拍照
@property(nonatomic, strong)UISpeakerButton *handsfreeButton; //  免提
@property(nonatomic, strong)UIMicroButton *intercomButton;  //  对讲
@property(nonatomic, strong)QJLBaseButton *unlockButton;    //  解锁
@property(nonatomic, strong)QJLBaseButton *hangupButton;    //  接听/挂断
@property(nonatomic, strong)QJLBaseView *videoView; //  视频view

@property(nonatomic, assign)BOOL *isSelected;   //  0为未接听   1为接听中


//- (void)displayIncomingCall:(LinphoneCall *)call;

@end
