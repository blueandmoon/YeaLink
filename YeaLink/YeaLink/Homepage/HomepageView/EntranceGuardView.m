//
//  EntranceGuardView.m
//  YeaLink
//
//  Created by 李根 on 16/4/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "EntranceGuardView.h"
#import "RemoteCell.h"

@interface EntranceGuardView ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation EntranceGuardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createView {
    _arr = [NSMutableArray arrayWithObjects:@"蓝牙开锁", @"远程门禁", nil];
    
    self.tableView = [[QJLBaseTableView alloc ]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50 * HEI;
    _tableView.tableFooterView = [[UIView alloc] init];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"reuse";
    RemoteCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[RemoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
//    if (indexPath.section == 0) {
//        cell.doorLabel.text = @"蓝牙开锁";
//    } else {
//        NSArray *arr = [NSArray arrayWithObjects:@"南门", @"北门", @"西门", @"东门", nil];
//        cell.doorLabel.text = arr[indexPath.row];
//    }
    
    cell.doorLabel.text = _arr[indexPath.row];
    
    return cell;
}
//  cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    } else {
//        return 4;
//    }
    return _arr.count;
}

//  点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%lu", indexPath.row);
    self.hidden = YES;
    self.jump(indexPath.row);
    
    
}




@end
