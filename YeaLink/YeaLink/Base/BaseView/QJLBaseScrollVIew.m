//
//  QJLBaseScrollVIew.m
//  YeaLink
//
//  Created by 李根 on 16/5/14.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseScrollVIew.h"

@implementation QJLBaseScrollVIew
{
    NSTimer *_timer;
    UIPageControl *_page;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
}

//+ (instancetype)scrollViewWithFrame:(CGRect)frame ImageArr:(NSMutableArray *)arr bgColor:(UIColor *)bgcolor {
//    QJLBaseScrollVIew *scrollview = [[QJLBaseScrollVIew alloc] init];
//    scrollview.backgroundColor = bgcolor;
//    scrollview.frame = frame;
//    
//    scrollview.contentSize = CGSizeMake(se, <#CGFloat height#>)
//    
//    return scrollview;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
