//
//  DropDownListView.m
//  YeaLink
//
//  Created by 李根 on 16/6/14.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "DropDownListView.h"
#import "AreaCell.h"
#import "OwnerModel.h"

@interface DropDownListView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DropDownListView

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
    cell.areaLabel.text = model.VName;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
