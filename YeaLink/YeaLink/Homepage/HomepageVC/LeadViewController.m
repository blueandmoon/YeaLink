//
//  LeadViewController.m
//  YeaLink
//
//  Created by 李根 on 16/6/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "LeadViewController.h"

@interface LeadViewController ()
{
    UIScrollView *scrollView;
    UIPageControl *page;
    NSArray *imageArr;
}
@end

@implementation LeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageArr = @[@"app引导页1-1tr", @"app引导页2-1tr", @"app引导页3-1tr"];
    [self createScrollView];
    
}

- (void)createScrollView {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(imageArr.count * WIDTH, 0);
    scrollView.pagingEnabled = YES;
    for (int i = 0; i < imageArr.count; i++) {
        QJLBaseImageView *imageView = [[QJLBaseImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        [scrollView addSubview:imageView];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        if (i == imageArr.count - 1) {
            [self addSwipeWith:imageView];   //  添加清扫手势
        }
    }
    
    //  跳过按钮
    QJLBaseButton *btn = [QJLBaseButton buttonCustomFrame:CGRectZero title:@"Skip" currentTitleColor:CUSTOMBLUE];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50 * WID, 30 * HEI));
        make.right.equalTo(self.view).with.offset(- 10 * WID);
        make.top.equalTo(self.view).with.offset(30 * HEI);
    }];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark    - 加了拖拽手势和向左清扫手势
- (void)addSwipeWith:(QJLBaseImageView *)imageView {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
    [imageView addGestureRecognizer:swipe];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UIPanGestureRecognizer *panToLeft = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
    [imageView addGestureRecognizer:panToLeft];
//    panToLeft.
    
    
}

- (void)btnClick:(id)sender {
    self.changeRootVC();
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
