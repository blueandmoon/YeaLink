//
//  DragButton.m
//  YeaLink
//
//  Created by 李根 on 16/6/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "DragButton.h"

static CGFloat startLocal;
static UIColor *startColor;

@interface DragButton ()
@property(nonatomic, assign)CGPoint startPoint;


@end

@implementation DragButton

- (instancetype)init {
    if (self = [super init]) {
        [self addTarget:self action:@selector(bgHighlight:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(bgNormal:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)bgHighlight:(id)sender {
    self.backgroundColor = CUSTOMBLUE;
}

- (void)bgNormal:(id)sender {
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    UITouch *touch = [touches anyObject];   //  获取触摸对象
    self.startPoint = [touch locationInView:self];  //  获取起始位置
    //  将初始x值保留
    startLocal = self.center.x;
//    startColor = self.cure
    NSLog(@"self.center.x: %f", self.center.x);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.backgroundColor = CUSTOMBLUE;
    
    UITouch *touch = [touches anyObject];
    CGPoint newPoint = [touch locationInView:self]; //  获取移动的坐标位置
    CGFloat dx = newPoint.x - self.startPoint.x;    //  计算移动的距离
//    NSLog(@"1 %f", startLocal);
//    NSLog(@"2 %f", 242 * WID);
//    NSLog(@"currentX: %f", self.center.x);
    
    if (self.center.x < 242 * WID + startLocal) {
        //  改变自身位置
        self.center = CGPointMake(self.center.x + dx, self.center.y);
    }
    
    
    self.beginDrag(self.center.x);
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //  滑动手势结束时判定位置
    if (self.center.x - startLocal > 242 * WID / 3) {
        //  拉过1/3就生效, 执行操作
        self.operate();
    }
    
    self.center = CGPointMake(startLocal, self.center.y);
//    self.changebgColor();
    if (self.tag == 101) {
        self.backgroundColor = [UIColor colorWithHex:0xdddddd];
    }
    self.endDrag();
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
