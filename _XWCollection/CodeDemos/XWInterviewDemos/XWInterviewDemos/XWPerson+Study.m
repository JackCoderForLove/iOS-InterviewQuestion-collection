//
//  XWPerson+Study.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/19.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "XWPerson+Study.h"
#import <objc/runtime.h>

@interface XWPerson ()

@end


@implementation XWPerson (Study)

- (double)getPersonHeight {
    return self.height;
}

- (void)saveHeight:(double)height {
    
    
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        Ivar var = vars[i];
        NSLog(@"%s", ivar_getName(var));
    }
    
    [XWPerson getAllMethods];

//    self.height = height;
}

/* 获取对象的所有方法 */
+(NSArray *)getAllMethods
{
    unsigned int methodCount =0;
    Method* methodList = class_copyMethodList([self class],&methodCount);
    NSMutableArray *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];
    
    for(int i=0;i<methodCount;i++)
    {
        Method temp = methodList[i];
        IMP imp = method_getImplementation(temp);
        SEL name_f = method_getName(temp);
        const char* name_s =sel_getName(method_getName(temp));
        int arguments = method_getNumberOfArguments(temp);
        const char* encoding =method_getTypeEncoding(temp);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,
              [NSString stringWithUTF8String:encoding]);
        [methodsArray addObject:[NSString stringWithUTF8String:name_s]];
    }
    free(methodList);
    return methodsArray;
}

@end
