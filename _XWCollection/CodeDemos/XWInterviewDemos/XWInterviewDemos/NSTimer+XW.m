//
//  NSTimer+XW.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/17.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "NSTimer+XW.h"

@implementation NSTimer (XW)

+ (NSTimer *)xw_timerTimeInterval:(NSTimeInterval)timeInterval block:(void(^)(void))block repeats:(BOOL)repeats {
    void(^inBlock)(void) = [block copy];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerMethod:) userInfo:inBlock repeats:repeats];
    return timer;
}

+ (void)timerMethod:(NSTimer *)timer {
    void(^inBlock)(void) = [timer userInfo];
    if (inBlock) {
        inBlock();
    }
}
@end
