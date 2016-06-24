//
//  DropListView.m
//  YeaLink
//
//  Created by 李根 on 16/6/15.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "DropListView.h"
#import "AreaCell.h"

@interface DropListView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DropListView

- (void)createView {
    _tableView = [[QJLBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50 * HEI;
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark    - 重写setter方法
- (void)setArr:(NSMutableArray *)arr {
    if (_arr != arr) {
        _arr = arr;
        [self.tableView reloadData];
    }
}

#pragma mark    - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"reuse";
    AreaCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[AreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    OwnerModel *model = _arr[indexPath.row];
    cell.areaLabel.text = [NSString stringWithFormat:@"%@%@栋", model.VName, model.BID];
    
    //  如果是没有选择, 就显示第一项
    if (indexPath.row == 0) {
        self.showTitle(model);
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OwnerModel *model = _arr[indexPath.row];
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:model.VName forKey:@"defaultName"];
    [userdef setObject:model.BID forKey:@"defaultBID"];
    [userdef setObject:model.Unit forKey:@"defautlUnit"];
    [userdef setObject:model.RID forKey:@"defautlRID"];
    [userdef synchronize];

    self.selectVillage();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
