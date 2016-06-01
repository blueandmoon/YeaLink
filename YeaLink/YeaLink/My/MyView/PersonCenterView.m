//
//  PersonCenterView.m
//  SI
//
//  Created by 李根 on 16/5/11.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "PersonCenterView.h"
#import "PersonCell.h"
#import "UserCell.h"
#import "SettingModel.h"

@interface PersonCenterView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PersonCenterView
{
    QJLBaseView *_bottomView;
    QJLBaseImageView *_iconView;
    QJLBaseLabel *_label;
}
- (void)createView {
//    _arr = [NSMutableArray array];
//    _arr = @[@"版本更新", @"服务约定", @"操作指南", @"二维码", @"收藏夹"];
    
    _tableview = [[QJLBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    [self addSubview:_tableview];
    
    _tableview.dataSource = self;
    _tableview.delegate = self;
    

    
}

- (void)setArr:(NSMutableArray *)arr {
    if (_arr != arr) {
        _arr = arr;
    }
    
    [_tableview reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.section);
    SettingModel *model = _arr[indexPath.section][indexPath.row];
    self.pushView(indexPath.section, [[UserInformation userinforSingleton].usermodel.APPUserRole integerValue]);
    [UserInformation userinforSingleton].strURL = model.ServicePath;
//    if (indexPath.section == 4) {
////        self.pushView();
//
//    } else {
////        self.jumpView();
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"[_arr[1] count] %lu", [_arr[1] count]);
//    NSLog(@"%@", model.ImageUrl);
    if (indexPath.section == 0) {
        SettingModel *model = _arr[indexPath.section][indexPath.row];
        static NSString *userReuse = @"userReuse";
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:userReuse];
        if (!cell) {
            cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userReuse];
        }
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.ImageUrl] placeholderImage:[UIImage imageNamed:@"placeholders"]];
        NSArray *arr = [model.Name componentsSeparatedByString:@"@"];
        cell.titlelabel.text = arr[0];
        cell.addressLabel.text = arr[1];
        
        return cell;
    } else {
        SettingModel *model = _arr[indexPath.section][indexPath.row];
        static NSString *reuse = @"reuse";
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.ImageUrl] placeholderImage:[UIImage imageNamed:@"placeholders"]];
        cell.label.text = model.Name;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f * HEI;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f * HEI;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f * HEI;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr.count;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
