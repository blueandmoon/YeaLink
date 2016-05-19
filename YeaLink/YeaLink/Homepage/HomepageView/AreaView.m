//
//  AreaView.m
//  YeaLink
//
//  Created by 李根 on 16/4/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AreaView.h"
#import "AreaCell.h"
#import "AreaModel.h"

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
    
}
//- (void)setArr:(NSMutableArray *)arr {
//    _arr = arr;
//    [self createView];
//}

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
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}
//  点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidden = YES;
}
//  分区标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"地区";
}


@end
