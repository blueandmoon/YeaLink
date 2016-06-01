//
//  BindingCellController.m
//  YeaLink
//
//  Created by 李根 on 16/5/20.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BindingCellController.h"

#define WDISTANCE 20 * WID
#define HDISTANCE 15 * HEI

@interface BindingCellController ()

@end

@implementation BindingCellController
{
    QJLBaseTextfield *_telField;
    QJLBaseTextfield *_codeField;
    QJLBaseTextfield *_defaultCellField;
    QJLBaseButton *_bindingBtn;
    BOOL isSelected;    //  是否勾选默认小区
    QJLBaseButton *_defaultBtn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingNavigationBar];
    [self getValue];
}

- (void)settingNavigationBar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI) text:@"绑定小区" titleColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
}

- (void)leftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getValue {
    _telField = [QJLBaseTextfield textfieldCustomWithFrame:CGRectZero placeholderText:@"请输入您的手机号" textAlignment:NSTextAlignmentLeft titlecolor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:_telField];
    _telField.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _telField.layer.borderWidth = 1;
    _telField.layer.cornerRadius = 5;
    _telField.tag = 101;
    _telField.text = [UserInformation userinforSingleton].usermodel.UserID;
    [_telField setValue:[NSNumber numberWithInt:15] forKey:@"paddingTop"];
    [_telField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(WDISTANCE);
        make.top.equalTo(self.view).with.offset(50 * HEI);
        make.height.mas_equalTo(50 * HEI);
        make.right.equalTo(self.view).with.offset(-WDISTANCE);
    }];
    [self addLeftViewWithTextField:_telField];
    
    _codeField = [QJLBaseTextfield textfieldCustomWithFrame:CGRectZero placeholderText:@"请输入您的注册码" textAlignment:NSTextAlignmentLeft titlecolor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:_codeField];
    _codeField.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _codeField.layer.borderWidth = 1;
    _codeField.layer.cornerRadius = 5;
    _codeField.tag = 102;
    [_codeField setValue:[NSNumber numberWithInt:15] forKey:@"paddingTop"];
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(WDISTANCE);
        make.top.equalTo(_telField.mas_bottom).with.offset(HDISTANCE);
        make.size.equalTo(_telField);
    }];
    [self addLeftViewWithTextField:_codeField];
    
    _defaultCellField = [QJLBaseTextfield textfieldCustomWithFrame:CGRectZero placeholderText:@"请输入您的注册码" textAlignment:NSTextAlignmentLeft titlecolor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:_defaultCellField];
    _defaultCellField.text = @"设置为默认小区";
//    _defaultCellField.enabled = NO;
    _defaultCellField.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _defaultCellField.layer.borderWidth = 1;
    _defaultCellField.layer.cornerRadius = 5;
    _defaultCellField.tag = 103;
    [_defaultCellField setValue:[NSNumber numberWithInt:15] forKey:@"paddingTop"];
    [_defaultCellField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(WDISTANCE);
        make.top.equalTo(_codeField.mas_bottom).with.offset(HDISTANCE);
        make.size.equalTo(_telField);
    }];
    //  给textfield加左视图
    [self addLeftViewWithTextField:_defaultCellField];
    //  由于enabled设为NO会把Button的点击事件也会禁止, 所以铺上一层view避免其编辑
    UIView *view = [[UIView alloc] init];
    [_defaultCellField addSubview:view];
    view.alpha = 1;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_defaultCellField).with.offset(30 * WID);
        make.right.equalTo(_defaultCellField).with.offset(0);
        make.top.equalTo(_defaultCellField).with.offset(0);
        make.height.equalTo(_defaultCellField);
    }];
    
    _bindingBtn = [QJLBaseButton buttonCustomFrame:CGRectZero title:@"绑定小区" currentTitleColor:[UIColor whiteColor]];
    [self.view addSubview:_bindingBtn];
    _bindingBtn.layer.cornerRadius = 5;
    _bindingBtn.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:105 / 255.0 blue:93 / 255.0 alpha:1];
    [_bindingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(WDISTANCE);
        make.top.equalTo(_defaultCellField.mas_bottom).with.offset(30 * HEI);
        make.size.equalTo(_telField);
    }];
    [_bindingBtn addTarget:self action:@selector(bindingAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark    - 加左视图
- (void)addLeftViewWithTextField:(QJLBaseTextfield *)textfield {
    textfield.leftViewMode = UITextFieldViewModeAlways;
    if (textfield.tag == 103) {
         _defaultBtn = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
        _defaultBtn.frame = CGRectMake(0, 0, 30 * WID, 30 * HEI);
        //    button.selected = YES;
//        button.backgroundColor = [UIColor blueColor];
        [_defaultBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_defaultBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _defaultCellField.leftView = _defaultBtn;
        
        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        if (![userdef objectForKey:@"isSelect"]) {
            NSLog(@"真的是空");
            isSelected = 1;
        } else {
            isSelected = [[userdef objectForKey:@"isSelect"] integerValue]; //
            NSLog(@"isSelected: %ld", isSelected);
            NSLog(@"不为空");
        }
        
        if ([[userdef objectForKey:@"isSelect"] isEqualToString:@"0"]) {
            [_defaultBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        } else {
            [_defaultBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        }
        
    } else {
        QJLBaseImageView *imageview = [[QJLBaseImageView alloc] initWithFrame:CGRectMake(0, 0, 30 * WID, 30 * HEI)];
        UIImage *image = nil;
        if (textfield.tag == 101) {
            image = [UIImage imageNamed:@"mobile"];
        } else {
            image = [UIImage imageNamed:@"PIN_Code"];
        }
        imageview.image = image;
        textfield.leftView = imageview;
    }
}
//  勾选默认小区的按钮
- (void)click:(id)sender {
    isSelected = !isSelected;
    if (isSelected == 1) {
        [_defaultBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    } else {
        [_defaultBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", isSelected] forKey:@"isSelect"];
    NSLog(@"____isSelected: %d", isSelected);
}

- (void)bindingAction:(id)sender {
//    http://qianjiale.doggadatachina.com/api/APIUserManage/UserBindVillage?UserID=13773240761&RegisterCode=155551&IsDefault=1
    
    NSString *str = [NSString stringWithFormat:@"%@api/APIUserManage/UserBindVillage?UserID=%@&RegisterCode=%@&IsDefault=%@",  COMMONURL, [UserInformation userinforSingleton].usermodel.UserID, _codeField.text, [NSString stringWithFormat:@"%d", isSelected]];
    NSLog(@"str: %@", str);
    
    NSString *title = nil;  //  提示信息
    if ([_telField.text length] && [_codeField.text length]) {
        [NetWorkingTool getNetWorking:str block:^(id result) {
            NSLog(@"%@", result);
            [self showAlertWithTitle:result[@"text"]];
            //  绑定成功则返回
            [self.navigationController popViewControllerAnimated:YES];
            
            //  个人用户绑定小区, 则返回刷新数据
            BOOL isPersonal = [[UserInformation userinforSingleton].usermodel.APPUserRole isEqualToString:@"1"];
            if (isPersonal) {
                self.refreshDataWithSwitchNeighbour();
            }
        }];
        
    } else {
        title = @"手机号和注册码不能为空";
    }
    [self showAlertWithTitle:title];
}

- (void)showAlertWithTitle:(NSString *)str {
    if ( str) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
