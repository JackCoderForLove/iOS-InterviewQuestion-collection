//
//  AppDelegate.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/12.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
static dispatch_once_t onceToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s",__func__);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%s",__func__);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    onceToken = 0;
   NSLog(@"%s",__func__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   NSLog(@"%s",__func__);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   NSLog(@"%s",__func__);
    
    dispatch_once(&onceToken, ^{
        NSLog(@"applicationDidBecomeActive once");
    });
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);
}


@end
