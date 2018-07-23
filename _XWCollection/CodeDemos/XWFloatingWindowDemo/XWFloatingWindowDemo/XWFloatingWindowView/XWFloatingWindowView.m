//
//  XWFloatingWindowView.m
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/22.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "XWFloatingWindowView.h"


@interface XWFloatingWindowView() {
    CGSize screenSize;
    CGPoint lastPoint;
}
@end

@implementation XWFloatingWindowView
//全局浮窗对象
static XWFloatingWindowView *xw_floatingWindowView;
//两边间距
static const CGFloat cFloatingWindowMargin = 20.0;
//浮窗宽度
static const CGFloat cFloatingWindowWidth = 60.0;

#pragma mark - publish
+ (void)show {
    if (!xw_floatingWindowView) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            xw_floatingWindowView = [[XWFloatingWindowView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - cFloatingWindowMargin, 200.0, cFloatingWindowWidth, cFloatingWindowWidth)];
        });
    }
    if (!xw_floatingWindowView.superview) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:xw_floatingWindowView];
        [keyWindow bringSubviewToFront:xw_floatingWindowView];
    }
}

#pragma mark - system
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        screenSize = UIScreen.mainScreen.bounds.size;
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.superview];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint curentPoint = [touch locationInView:self.superview];
    CGPoint selfPoint = [touch locationInView:self];
    
    
//    self.center = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    if (CGPointEqualToPoint(lastPoint, currentPoint)) {
        NSLog(@"单击!");
    }else{
        
    }
}
@end
