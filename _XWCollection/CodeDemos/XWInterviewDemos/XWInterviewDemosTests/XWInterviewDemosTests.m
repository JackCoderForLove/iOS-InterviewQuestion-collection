//
//  XWInterviewDemosTests.m
//  XWInterviewDemosTests
//
//  Created by 邱学伟 on 2018/7/12.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XWInterviewDemosTests : XCTestCase

@end

@implementation XWInterviewDemosTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testArrayDeal {
    NSMutableArray *array = @[@1,@2,@3].mutableCopy;
    
    [self arrayDeal:array];
    
    NSLog(@"array  : %@",array);
}

- (void)arrayDeal:(NSMutableArray *)arrayM {
    [arrayM insertObject:@"10086" atIndex:0];
}


// 冒泡3-优化
- (void)testSort3Array {
    NSUInteger count = 0;
    BOOL isNonSorted = YES;
    //@[@16,@1,@2,@9,@7,@12,@5,@3,@8,@13,@10]
    NSMutableArray *array = @[@16,@122,@9,@7,@6,@5,@4,@3,@2,@1].mutableCopy;
    for (int i = 0; i < array.count && isNonSorted; i++) {
        isNonSorted = NO;
        for (int j = (int)array.count - 2; j >= i; j--) {
            count++;
            NSNumber *objPre = array[j];
            NSNumber *objNext = array[j+1];
            if (objPre.integerValue < objNext.integerValue) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                isNonSorted = YES;
            }
        }
        [self logArr:array];
    }
    NSLog(@"%lu 次比较!!",(unsigned long)count); //17
}

// 冒泡2
- (void)testSort2Array {
    NSUInteger count = 0;
    NSMutableArray *array = @[@16,@122,@9,@7,@6,@5,@4,@3,@2,@1].mutableCopy;
    for (int i = 0; i < array.count; i++) {
        for (int j = (int)array.count - 2; j >= i; j--) {
            count++;
            NSNumber *objPre = array[j];
            NSNumber *objNext = array[j+1];
            if (objPre.integerValue < objNext.integerValue) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
        [self logArr:array];
    }
    NSLog(@"%lu 次比较!!",(unsigned long)count); //45
}

// 冒泡1
- (void)testSort1Array {
    NSUInteger count = 0;
    NSMutableArray *array = @[@16,@122,@9,@7,@6,@5,@4,@3,@2,@1].mutableCopy;
    for (int i = 0; i < array.count; i++) {
        for (int j = i+1; j < array.count; j++) {
            count++;
            NSNumber *objPre = array[i];
            NSNumber *objNext = array[j];
            if (objPre.integerValue < objNext.integerValue) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
        [self logArr:array];
    }
    [self logArr:array];
    NSLog(@"%lu 次比较!!",(unsigned long)count); //45 次比较
}
- (void)logArr:(NSMutableArray * )array {
    NSString * str = @"";
    for (NSNumber * value in array) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%zd ",[value integerValue]]];
    }
    NSLog(@"%@",str);
}


- (void)testExample {
    NSString *ip = @"1.1.1.1";
    XCTAssertTrue([self ipIsValidity2:ip]);
}

//正则:
//String ipRegEx = "^([1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))(\\.([0-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))){3}$";
//String ipRegEx = "^([1-9]|([1-9]\\d)|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))(\\.(\\d|([1-9]\\d)|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))){3}$";
//String ipRegEx = "^(([1-9]\\d?)|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))(\\.(0|([1-9]\\d?)|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))){3}$";
- (BOOL)ipIsValidity2:(NSString *)ip {
    NSString  *isIP = @"^([1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))(\\.([0-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))){3}$";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:isIP options:0 error:nil];
    NSArray *results = [regular matchesInString:ip options:0 range:NSMakeRange(0, ip.length)];
    return results.count > 0;
}

- (BOOL)ipIsValidity1:(NSString *)ip {
//    (1~255).(0~255).(0~255).(0~255)
    if (!ip || ip.length < 7 || ip.length > 15) {
        return NO;
    }
    
    //首末字符判断，如果是"."则是非法IP
    if ([[ip substringToIndex:1] isEqualToString:@"."]) {
        return NO;
    }
    if ([[ip substringFromIndex:ip.length - 1] isEqualToString:@"."]) {
        return NO;
    }
    
    NSArray <NSString *> *subIPArray = [ip componentsSeparatedByString:@"."];
    if (subIPArray.count != 4) {
        return NO;
    }
    
    for (NSInteger i = 0; i < 4; i++) {
        NSString *subIP = subIPArray[i];
        
        if (subIP.length > 1 && [[subIP substringToIndex:1] isEqualToString:@"0"]) {
            //避免出现 01.  011.
            return NO;
        }
        for (NSInteger j = 0; j < subIP.length; j ++) {
            char temp = [subIP characterAtIndex:j];
            if (temp < '0' || temp > '9') {
                //避免出现 11a.19b.s.s
                return NO;
            }
        }
        
        NSInteger subIPInteger = subIP.integerValue;
        if (i == 0) {
            if (subIPInteger < 1 || subIPInteger > 255) {
                return NO;
            }
        }else{
            if (subIPInteger < 0 || subIPInteger > 255) {
                return NO;
            }
        }
    }
    return YES;
}

@end
