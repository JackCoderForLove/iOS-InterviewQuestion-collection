//
//  XWFloatingWindowView.m
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/22.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "XWFloatingWindowView.h"
#import "XWFloatingWindowContentView.h"

@interface XWFloatingWindowView() {
    CGSize screenSize;
    CGPoint lastPointInSuperView;
    CGPoint lastPointInSelf;
}
@end

@implementation XWFloatingWindowView
//全局浮窗
static XWFloatingWindowView *xw_floatingWindowView;
//全局隐藏浮窗视图
static XWFloatingWindowContentView *xw_floatingWindowContentView;
//两边间距
static const CGFloat cFloatingWindowMargin = 20.0;
//浮窗宽度
static const CGFloat cFloatingWindowWidth = 60.0;
//隐藏浮窗视图宽度
static const CGFloat cFloatingWindowContentWidth = 160.0;
//默认动画时间
static const NSTimeInterval cFloatingWindowAnimtionDefaultDuration = 0.25;


#pragma mark - publish
+ (void)show {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xw_floatingWindowView = [[XWFloatingWindowView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - cFloatingWindowWidth * 2 - cFloatingWindowMargin, 200.0, cFloatingWindowWidth, cFloatingWindowWidth)];
        
        xw_floatingWindowContentView = [[XWFloatingWindowContentView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height, cFloatingWindowContentWidth, cFloatingWindowContentWidth)];
    });
//    xw_floatingWindowContentView.frame = CGRectMake(200, 200, cFloatingWindowContentWidth, cFloatingWindowContentWidth);
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!xw_floatingWindowContentView.superview) {
        [keyWindow addSubview:xw_floatingWindowContentView];
        [keyWindow bringSubviewToFront:xw_floatingWindowContentView];
    }
    if (!xw_floatingWindowView.superview) {
        [keyWindow addSubview:xw_floatingWindowView];
        [keyWindow bringSubviewToFront:xw_floatingWindowView];
    }
}

#pragma mark - system
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    lastPointInSuperView = [touch locationInView:self.superview];
    lastPointInSelf = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint curentPoint = [touch locationInView:self.superview];
    
    /// 展开 右下浮窗隐藏视图
    if (!CGPointEqualToPoint(lastPointInSuperView, curentPoint)) {
        /// 有移动才展开
        CGRect rect = CGRectMake(screenSize.width - cFloatingWindowContentWidth, screenSize.height - cFloatingWindowContentWidth, cFloatingWindowContentWidth, cFloatingWindowContentWidth);
        if (!CGRectEqualToRect(xw_floatingWindowContentView.frame, rect)) {
            [UIView animateWithDuration:cFloatingWindowAnimtionDefaultDuration animations:^{
                xw_floatingWindowContentView.frame = rect;
            }];
        }
    }
    
    /// 调整浮窗中心点
    CGFloat halfWidth = self.frame.size.width * 0.5;
    CGFloat halfHeight = self.frame.size.height * 0.5;
    CGFloat centerX = curentPoint.x + (halfWidth - lastPointInSelf.x);
    CGFloat centerY = curentPoint.y + (halfHeight - lastPointInSelf.y);
    CGFloat x = MIN(screenSize.width - halfWidth, MAX(centerX, halfWidth));
    CGFloat y = MIN(screenSize.height - halfHeight, MAX(centerY, halfHeight));
    self.center = CGPointMake(x,y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    if (CGPointEqualToPoint(lastPointInSuperView, currentPoint)) {
        NSLog(@"单击!");
    }else{
        
        /// 收缩 右下浮窗隐藏视图
        [UIView animateWithDuration:cFloatingWindowAnimtionDefaultDuration animations:^{
            /// 浮窗在隐藏视图内部,移除浮窗
            CGFloat distance = sqrtf( (pow(self->screenSize.width - xw_floatingWindowView.center.x,2) + pow(self->screenSize.height - xw_floatingWindowView.center.y, 2)) );
            if (distance < (cFloatingWindowContentWidth - cFloatingWindowWidth * 0.5)) {
                [self removeFromSuperview];
            }
            
            xw_floatingWindowContentView.frame = CGRectMake(self->screenSize.width, self->screenSize.height, cFloatingWindowContentWidth, cFloatingWindowContentWidth);
        }];
        
        CGFloat left = currentPoint.x;
        CGFloat right = screenSize.width - currentPoint.x;
        if (left <= right) {
            [UIView animateWithDuration:cFloatingWindowAnimtionDefaultDuration animations:^{
                self.center = CGPointMake(cFloatingWindowMargin + self.bounds.size.width * 0.5, self.center.y);
            }];
        }else{
            [UIView animateWithDuration:cFloatingWindowAnimtionDefaultDuration animations:^{
                self.center = CGPointMake(self->screenSize.width - cFloatingWindowMargin - self.bounds.size.width * 0.5, self.center.y);
            }];
        }
    }
}

#pragma mark - private
- (void)setupUI {
    screenSize = UIScreen.mainScreen.bounds.size;
    self.backgroundColor = [UIColor clearColor];
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"FloatBtn"].CGImage;
}
@end
