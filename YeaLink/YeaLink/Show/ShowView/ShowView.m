//
//  ShowView.m
//  YeaLink
//
//  Created by 李根 on 16/6/15.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ShowView.h"
#import "AreaCell.h"

@interface ShowView ()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation ShowView
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
//        //  重新绘制
//        [self setNeedsDisplay];
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
    cell.areaLabel.text = _arr[indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectVillage(_arr[indexPath.row]);
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
