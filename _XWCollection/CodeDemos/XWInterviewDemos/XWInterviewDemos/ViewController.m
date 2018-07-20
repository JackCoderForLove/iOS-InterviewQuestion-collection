//
//  ViewController.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/12.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <pthread.h>
#import "XWPerson.h"
#import "XWStudent.h"
#import "SecondViewController.h"
#import "XWPerson.h"
#import "XWPerson+Study.h"

typedef struct XWSize {
    CGFloat width;
    CGFloat height;
}TestSize;

typedef void(^XWVoidBlock)(void);
typedef void(^XWBlock)(NSString *str);
typedef void(^XWLogBlock)(NSArray *array);

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *toSecondBtn;
@property (weak, nonatomic) IBOutlet UIView *redView;

@property (atomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSArray *originArray;
@property (nonatomic, strong) NSMutableArray *conditionArray;
@property (nonatomic, strong) NSCondition *xwCondition;

@property (nonatomic, copy) NSMutableArray *xw_mutableCopyArray;

@property (nonatomic, strong) XWPerson *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testLoad2];
    
//    [self setupRunloopObserver];
//
//    self.array = [NSMutableArray array];
//
//    self.originArray = @[@1,@2,@3];
//
//    self.conditionArray = [NSMutableArray array];
//    self.xwCondition = [[NSCondition alloc] init];
//
//    [self testLoad2];
    
//    [self.person saveHeight:180];
    
//    [self testCopy1];
//    [self lock18];
    
//    [self performDemo3];
//    [self performDemo2selector:@selector(performDemoNumber1:Number2:Number3:) withObjects:@[@1.0,@2.0,@3.0]];
//    [self performDemo1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"person height : %f",[self.person getPersonHeight]);
    
//    NSLog(@" xw_mutableCopyArray:%p",self.xw_mutableCopyArray);
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSLog(@"viewDidAppear once");
//    });
    
}
- (IBAction)topBtnClick:(id)sender {
    NSLog(@"click");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.redView.bounds = CGRectMake(0, 0, 300, 300);
}

- (void)setupRunloopObserver
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        
        CFRunLoopObserverRef enterObserver;
        enterObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                                kCFRunLoopEntry | kCFRunLoopExit,
                                                true,
                                                -0x7FFFFFFF,
                                                BBRunloopObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, enterObserver, kCFRunLoopCommonModes);
        CFRelease(enterObserver);
    });
}

static void BBRunloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            NSLog(@"enter runloop...");
        }
            break;
        case kCFRunLoopExit: {
            NSLog(@"leave runloop...");
        }
            break;
        default: break;
    }
}


- (IBAction)toSecondVCClick:(id)sender {
    SecondViewController *secVC = [SecondViewController loadViewController];
    [self.navigationController pushViewController:secVC animated:YES];
}

- (void)testLoad2 {
//    XWPerson *p1 = [[XWPerson alloc] init];
//    XWPerson *p2 = [[XWPerson alloc] init];
//    XWStudent *p3 = [[XWStudent alloc] init];
    XWStudent *p4 = [[XWStudent alloc] init];
    NSLog(@"p4:%p",p4);
//    NSLog(@"p1:%p  -  p2:%p  -  p3:%p  -  p4:%p",p1,p2,p3,p4);
}

- (void)testLoad {
    XWPerson *p1 = [[XWPerson alloc] init];
    XWPerson *p2 = [[XWPerson alloc] init];
    XWPerson *p3 = [[XWPerson alloc] init];
    XWPerson *p4 = [[XWPerson alloc] init];
    NSLog(@"p1:%p  -  p2:%p  -  p3:%p  -  p4:%p",p1,p2,p3,p4);
}

- (void)testCopy1 {
    NSMutableArray *array = [NSMutableArray arrayWithObject:@[@1,@2,@3]];
    self.xw_mutableCopyArray = array;
    NSLog(@"array:%p -------- xw_mutableCopyArray:%p",array,self.xw_mutableCopyArray);
}


- (void)linkedDemo1 {
    
}



- (void)lock18 {
    NSLog(@"start");
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"sync...main_queue");
//    });
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"sync...global_queue");
    });
    NSLog(@"end");
}

- (void)lock17 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 1000; i++) {
            [self.array addObject:@(i)];
            NSLog(@"线程一 %d --- %@ ----- firstOBJ:%@",i,[NSThread currentThread],self.array.firstObject);
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 10; i++) {
            if (i == 9) {
                self.array = nil;
                NSLog(@"======= nil");
            }
            NSLog(@"线程二 %d --- %@",i,[NSThread currentThread]);
        }
    });
}

- (void)lock16 {
    pthread_once_t once = PTHREAD_ONCE_INIT;
    pthread_once(&once, lock16Func);
}
void lock16Func() {
     static id shareInstance;
    shareInstance = [[NSObject alloc] init];
}

- (id)lock15 {
    static id shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance = [[NSObject alloc] init];
        }
    });
    return shareInstance;
}

- (void)lock14 {
    __block pthread_rwlock_t rwlock;
    pthread_rwlock_init(&rwlock, NULL);
    __block NSMutableArray *arrayM = [NSMutableArray array];
    
    XWBlock writeBlock = ^ (NSString *str) {
        NSLog(@"开启写操作");
        pthread_rwlock_wrlock(&rwlock);
        [arrayM addObject:str];
        sleep(2);
        pthread_rwlock_unlock(&rwlock);
    };
    
    XWVoidBlock readBlock = ^ {
        NSLog(@"开启读操作");
        pthread_rwlock_rdlock(&rwlock);
        sleep(1);
        NSLog(@"读取数据:%@",arrayM);
        pthread_rwlock_unlock(&rwlock);
    };
    
    for (int i = 0; i < 5; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            writeBlock([NSString stringWithFormat:@"%d",i]);
        });
    }
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            readBlock();
        });
    }
}

- (void)lock13 {
    dispatch_queue_t queue = dispatch_queue_create("com.qiuxuewei.brrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"任务1 -- %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务2 -- %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务3 -- %@",[NSThread currentThread]);
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"任务0 -- %@",[NSThread currentThread]);
        for (int i = 0; i < 100; i++) {
            if (i % 30 == 0) {
                NSLog(@"任务0 --- log:%d -- %@",i,[NSThread currentThread]);
            }
        }
    });
    NSLog(@"dispatch_barrier_sync  down!!!");
    dispatch_async(queue, ^{
        NSLog(@"任务4 -- %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务5 -- %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"任务6 -- %@",[NSThread currentThread]);
    });
}

- (void)lock12 {
    __block pthread_mutex_t mutex;
    __block pthread_cond_t condition;
    
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&condition, NULL);
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&mutex);
        
        for (int i = 0; i < 6; i++) {
            [arrayM addObject:@(i)];
            NSLog(@"异步下载第 %d 张图片",i);
            sleep(1);
            if (arrayM.count == 4) {
                pthread_cond_signal(&condition);
            }
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        pthread_cond_wait(&condition, &mutex);
        NSLog(@"已经获取到4张图片->主线程渲染");
        pthread_mutex_unlock(&mutex);
    });
}

- (void)lock11 {
    NSConditionLock *conditionLock = [[NSConditionLock alloc] init];
    NSMutableArray *arrayM = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [conditionLock lock];
        
        for (int i = 0; i < 6; i++) {
            [arrayM addObject:@(i)];
            NSLog(@"异步下载第 %d 张图片",i);
            sleep(1);
            if (arrayM.count == 4) {
                [conditionLock unlockWithCondition:4];
            }
        }
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [conditionLock lockWhenCondition:4];
        NSLog(@"已经获取到4张图片->主线程渲染");
        [conditionLock unlock];
    });
}

- (void)lock10 {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.xwCondition lock];
        if (self.conditionArray.count == 0) {
            NSLog(@"等待制作数组");
            [self.xwCondition wait];
        }
        id obj = self.conditionArray[0];
        NSLog(@"获取对象进行操作:%@",obj);
        [self.xwCondition unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.xwCondition lock];
        id obj = @"极客学伟";
        [self.conditionArray addObject:obj];
        NSLog(@"创建了一个对象:%@",obj);
        [self.xwCondition signal];
        [self.xwCondition unlock];
    });
}

- (void)lock9 {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self removeLastImage:self.originArray.mutableCopy];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addImages:self.originArray.mutableCopy];
    });
}
- (void)addImages:(NSMutableArray *)images {
    [images addObject:@4];
    [images addObject:@5];
    [images addObject:@6];
    NSLog(@"addImages : %@",images);
}
- (NSMutableArray *)removeLastImage:(NSMutableArray *)images {
    if (images.count > 0) {
        NSCondition *condition = [[NSCondition alloc] init];
        [condition lock];
        [images removeLastObject];
        [condition unlock];
        NSLog(@"removeLastImage %@",images);
        return images;
    }else{
        return NULL;
    }
}

- (void)lock8 {
    __block pthread_mutex_t semaphore = PTHREAD_MUTEX_INITIALIZER;
    __block pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
    
    NSLog(@"start");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&semaphore);
        NSLog(@"async...");
        sleep(5);
        pthread_cond_signal(&cond);
        pthread_mutex_unlock(&semaphore);
    });
    
    pthread_cond_wait(&cond, &semaphore);
    NSLog(@"end");
}

- (void)lock7 {
//    dispatch_semaphore_create //创建一个信号量 semaphore
//    dispatch_semaphore_signal //发送一个信号 信号量+1
//    dispatch_semaphore_wait   // 等待信号 信号量-1
    
    /// 需求: 异步线程的两个操作同步执行
    
    dispatch_semaphore_t semaphone = dispatch_semaphore_create(0);
    NSLog(@"start");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"async .... ");
        sleep(5);
        /// 线程资源 + 1
        dispatch_semaphore_signal(semaphone);//信号量+1
    });
    /// 当前线程资源数量为 0 ,等待激活
    dispatch_semaphore_wait(semaphone, DISPATCH_TIME_FOREVER);
    NSLog(@"end");
}

- (void)lock6 {
    __block pthread_mutex_t recursiveMutex;
    pthread_mutexattr_t recursiveMutexattr;
    
    pthread_mutexattr_init(&recursiveMutexattr);
    pthread_mutexattr_settype(&recursiveMutexattr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&recursiveMutex, &recursiveMutexattr);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^XWRecursiveBlock)(int);
        
        XWRecursiveBlock = ^(int  value) {
            pthread_mutex_lock(&recursiveMutex);
            if (value > 0) {
                NSLog(@"加锁层数: %d",value);
                sleep(1);
                XWRecursiveBlock(--value);
            }
            NSLog(@"程序退出!");
            pthread_mutex_unlock(&recursiveMutex);
        };
        
        XWRecursiveBlock(3);
    });
}


- (void)lock5 {
    NSLock *commonLock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^XWRecursiveBlock)(int);
        
        XWRecursiveBlock = ^(int  value) {
            [commonLock lock];
            if (value > 0) {
                NSLog(@"加锁层数: %d",value);
                sleep(1);
                XWRecursiveBlock(--value);
            }
            NSLog(@"程序退出!");
            [commonLock unlock];
        };
        
        XWRecursiveBlock(3);
    });
}

- (void)lock4 {
    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^XWRecursiveBlock)(int);
        
        XWRecursiveBlock = ^(int  value) {
            [recursiveLock lock];
            if (value > 0) {
                NSLog(@"加锁层数: %d",value);
                sleep(1);
                XWRecursiveBlock(--value);
            }
            NSLog(@"程序退出!");
            [recursiveLock unlock];
        };
        
        XWRecursiveBlock(3);
    });
}

- (void)lock3 {

    __block pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"+++++ 线程1 start");
        pthread_mutex_lock(&mutex);
        sleep(2);
        pthread_mutex_unlock(&mutex);
        NSLog(@"+++++ 线程1 end");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"----- 线程2 start");
        pthread_mutex_lock(&mutex);
        sleep(3);
        pthread_mutex_unlock(&mutex);
        NSLog(@"----- 线程2 end");
    });
}

- (void)lock2 {
    NSLock *xwlock = [[NSLock alloc] init];
    XWLogBlock logBlock = ^ (NSArray *array) {
        [xwlock lock];
        for (id obj in array) {
            NSLog(@"%@",obj);
        }
        [xwlock unlock];
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = @[@1,@2,@3];
        logBlock(array);
    });
}

- (void)lock1 {
    @synchronized (self) {
        // 加锁操作
    }
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

- (XWPerson *)person {
    if(!_person){
        _person = [[XWPerson alloc] init];
    }
    return _person;
}

@end
