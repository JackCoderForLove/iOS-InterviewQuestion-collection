//
//  SecondView.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/17.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "SecondView.h"

@implementation SecondView
- (void)drawRect:(CGRect)rect {
//    [self drawCircle];
    
    [self drawFang];
}

- (void)drawFang {
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect angle = CGRectMake(10, 10, 100, 80);
    CGPathAddRect(path, NULL, angle);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    
    [[UIColor redColor] setFill];
    [[UIColor greenColor] setStroke];
    
    CGContextSetLineWidth(context, 3.0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPathRelease(path);
}


- (void)drawSanjiao2 {
    
}

- (void)drawSanjiao {
    [[UIColor yellowColor] set];
    UIRectFill(self.bounds);
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contex);
    CGContextMoveToPoint(contex, 50, 50);
    CGContextAddLineToPoint(contex, 100, 50);
    CGContextAddLineToPoint(contex, 75, 100);
    CGContextClosePath(contex);
    
    [[UIColor redColor] setFill];
    [[UIColor greenColor] setStroke];
    
    CGContextDrawPath(contex, kCGPathFillStroke);
}


@end
