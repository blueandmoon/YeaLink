//
//  AreaView.m
//  YeaLink
//
//  Created by 李根 on 16/4/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AreaView.h"
#import "AreaCell.h"

@interface AreaView ()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation AreaView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createView {
    self.tableView = [[QJLBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50 * HEI;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}
- (void)setArr:(NSMutableArray *)arr {
    if (_arr != arr) {
        _arr = arr;
    }
    [_tableView reloadData];
}

//  delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"reuse";
    AreaCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[AreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    AreaModel *model = [[AreaModel alloc] init];
    model = self.arr[indexPath.row];
    cell.areaLabel.text = model.cityName;
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"cityID"]) {
        if (0 == indexPath.row) {
            [self saveDefaultCityWith:model];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

//  点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  存储用户所选城市
    AreaModel *model = _arr[indexPath.row];
    [self saveDefaultCityWith:model];
    
//    self.changeCity(model);
    
    self.hidden = YES;
}

//  分区标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"地区";
}

#pragma mark    - 存储默认城市
- (void)saveDefaultCityWith:(AreaModel *)model {
    //  判断点击的城市不是当前城市, 先判断是否存储过cityid, 若无, 则是第一次, 则~
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cityID"] != nil) {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"cityID"] isEqualToString:model.cityID]) {
            [self saveInfoWithModel:model];
        }
    } else {
        [self saveInfoWithModel:model];
    }
}

- (void)saveInfoWithModel:(AreaModel *)model {
    //  存储用户所选城市信息, 用户无默认城市则默认选第一个
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:model.cityName forKey:@"cityName"];
    [userdef setObject:model.cityID forKey:@"cityID"];
    [userdef synchronize];
        //  用单例存储用户所选城市
//    [UserInformation userinforSingleton].cityID = model.cityID;
//    [UserInformation userinforSingleton].cityName = model.cityName;
    //    NSLog(@"%@", NSHomeDirectory());
    //  设置导航栏左按钮的标题
    self.setLeftNavigationItem(model);
}

@end
