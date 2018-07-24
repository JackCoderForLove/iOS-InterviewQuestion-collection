//
//  XWFloatingWindowContentView.m
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/22.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "XWFloatingWindowContentView.h"

@interface XWFloatingWindowContentView()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) CATextLayer *textLayer;
@end

@implementation XWFloatingWindowContentView

#pragma mark - system
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - private
- (void)setupUI {
    [self.layer addSublayer:self.shapeLayer];
    [self.layer addSublayer:self.imageLayer];
    [self.layer addSublayer:self.textLayer];
    
    CGFloat imageW = 50.0;
    _imageLayer.frame = CGRectMake(0.5 * (self.frame.size.width - imageW), 0.5 * (self.frame.size.height - imageW), imageW, imageW);
    _textLayer.frame = CGRectMake(_imageLayer.frame.origin.x, CGRectGetMaxY(_imageLayer.frame), _imageLayer.frame.size.width, 20);
}

#pragma mark - getter
- (CAShapeLayer *)shapeLayer {
    if(!_shapeLayer){
        _shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width, self.frame.size.height) radius:self.frame.size.width startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [path closePath];
        
        _shapeLayer.path = path.CGPath;
        _shapeLayer.fillColor = [UIColor colorWithRed:206/255.0 green:85/255.0 blue:85/255.0 alpha:1].CGColor;;
    }
    return _shapeLayer;
}

- (CALayer *)imageLayer {
    if(!_imageLayer){
        _imageLayer = [[CALayer alloc] init];
        _imageLayer.contents = (__bridge id)[UIImage imageNamed:@"CornerIcon"].CGImage;
    }
    return _imageLayer;
}

- (CATextLayer *)textLayer {
    if(!_textLayer){
        _textLayer = [[CATextLayer alloc] init];
        _textLayer.string = @"取消浮窗";
        _textLayer.fontSize = 12.0;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.foregroundColor = [UIColor colorWithRed:234.f/255.0 green:160.f/255.0 blue:160.f/255.0 alpha:1].CGColor;
    }
    return _textLayer;
}
@end
