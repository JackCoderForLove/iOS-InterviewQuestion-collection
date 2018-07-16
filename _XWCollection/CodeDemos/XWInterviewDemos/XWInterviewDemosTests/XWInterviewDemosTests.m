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
