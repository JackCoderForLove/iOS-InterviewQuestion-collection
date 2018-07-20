//
//  XWPerson.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/17.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "XWPerson.h"

@interface XWPerson()
@property (nonatomic, copy) NSString *age;

@property (nonatomic, assign, readwrite) double height;
@end

@implementation XWPerson
+ (void)initialize {
    NSLog(@"%s",__func__);
}

+(void)load {
    NSLog(@"%s",__func__);
}
@end
