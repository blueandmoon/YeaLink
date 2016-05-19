//
//  BaseScrollView.m
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseScrollView.h"
#import "ServiceModel.h"

@interface BaseScrollView ()<UIScrollViewDelegate>
@property(nonatomic, strong)UIPageControl *page;


@end

@implementation BaseScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)createView {
    
    
    if (_arr.count != 0) {
        //    NSLog(@"self.arr.count: %lu", self.arr.count);
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_scrollview];
        _scrollview.contentSize = CGSizeMake((_arr.count + 1) * self.frame.size.width, 0);
        _scrollview.pagingEnabled = YES;
        _scrollview.bounces = NO;
        _scrollview.delegate = self;
        
        for (NSInteger i = 0; i < _arr.count; i ++) {
            ServiceModel *model = _arr[i];
            QJLBaseImageView *imageview = [[QJLBaseImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [_scrollview addSubview:imageview];
            [imageview sd_setImageWithURL:[NSURL URLWithString:model.IconPath] placeholderImage:[UIImage imageNamed:@"placeholders"]];
        }
        //  把第一张放在最后
        ServiceModel *model = _arr[0];
        QJLBaseImageView *imageview = [[QJLBaseImageView alloc] initWithFrame:CGRectMake(_arr.count * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [_scrollview addSubview:imageview];
        [imageview sd_setImageWithURL:[NSURL URLWithString:model.IconPath] placeholderImage:[UIImage imageNamed:@"placeholders"]];
        
        //  pageControl
        _page = [[UIPageControl alloc] initWithFrame:CGRectMake(150 * WID, 120 * HEI, 75 * WID, 30 * HEI)];
        [self addSubview:_page];
        _page.numberOfPages = _arr.count;
        //  未被选中的颜色
        _page.pageIndicatorTintColor = [UIColor blackColor];
        //  选中的颜色
        _page.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_page addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
        //  定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeIcon) userInfo:nil repeats:YES];
    
    }
    
    
}

- (void)setArr:(NSMutableArray *)arr {
    _arr = arr;
//    NSLog(@"%lu", _arr.count);
//    [self reloadInputViews];
    [self createView];
}

- (void)changePage:(UIPageControl *)page {
    
}

- (void)changeIcon {
    [_scrollview setContentOffset:CGPointMake(_scrollview.contentOffset.x + self.frame.size.width, 0) animated:YES];
    if (_scrollview.contentOffset.x == _arr.count * self.frame.size.width) {
        _scrollview.contentOffset = CGPointMake(0, 0);
    }
}

//  UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrollview.contentOffset.x == _arr.count * self.frame.size.width) {
        _scrollview.contentOffset = CGPointMake(0 , 0);
    }
    _page.currentPage = _scrollview.contentOffset.x / self.frame.size.width;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
