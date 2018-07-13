//
//  ViewController.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/12.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

typedef struct XWSize {
    CGFloat width;
    CGFloat height;
}TestSize;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performDemo3];
//    [self performDemo2selector:@selector(performDemoNumber1:Number2:Number3:) withObjects:@[@1.0,@2.0,@3.0]];
//    [self performDemo1];
}

- (void)performDemo3 {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    TestSize testSize = {10086.00,10010.00};
    NSValue *testSizeValue = [NSValue valueWithBytes:&testSize objCType:@encode(TestSize)];
    [dict setObject:testSizeValue forKey:@"testSize"];
    [self performSelector:@selector(performDemoStructDict:) withObject:dict];
}

- (void)performDemoStructDict:(NSDictionary *)dict {
    NSValue *testSizeStruct = dict[@"testSize"];
    TestSize inputSize;
    [testSizeStruct getValue:&inputSize];
    NSLog(@"width: %f  ++  height: %f",inputSize.width,inputSize.height);
}

- (id)performDemo2selector:(SEL)selector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (!signature) {
        NSLog(@"无此方法");
        return nil;
    }
    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    invocation.target = self;
    
    // 除self、_cmd以外的参数个数
    NSInteger paramCount = signature.numberOfArguments - 2;
    for (NSUInteger i = 0; i < paramCount; i++) {
        if (objects.count > i) {
            id obj = objects[i];
            if ([obj isKindOfClass:[NSNull class]]) {
                continue;
            }
            [invocation setArgument:&obj atIndex:i + 2];
        }
    }
    
    [invocation invoke];
    
    id returnValue = nil;
    if (signature.methodReturnLength) {
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}

- (NSNumber *)performDemoNumber1:(NSNumber *)number1 Number2:(NSNumber *)number2 Number3:(NSNumber *)number3 {
    double numb = number1.doubleValue + number2.doubleValue + number3.doubleValue;
    NSLog(@"和:%f",numb);
    return [NSNumber numberWithDouble:numb];
}

- (void)performDemo1 {
    NSDictionary *dict = @{
                           @"name":@"极客学伟",
                           @"age":@18
                           };
    [self performSelector:@selector(performDemoDict:) withObject:dict];
}
- (void)performDemoDict:(NSDictionary *)dict {
    NSLog(@"%@",dict);
}

@end
