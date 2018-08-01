//
//  MainViewController.m
//  RunLoops
//
//  Created by QSP on 2018/7/31.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "MainViewController.h"
#import "CommonDefine.h"
#import <Foundation/Foundation.h>

@interface MainViewController ()<NSPortDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    K_WeakSelf
    self.title = @"RunLoop";
    self.tableView.vmCreate(^(QSPTableViewVM *vm){
        vm.addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [NSThread detachNewThreadSelector:@selector(mainThread) toTarget:weakSelf withObject:nil];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"创建运行循环观察器").detailSet(@"创建一个CFRunLoopObserverRef opaque类型并使用CFRunLoopAddObserver函数将其添加到运行循环中。必须使用Core Foundation创建运行循环观察器，即使对于Cocoa应用程序也是如此。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [NSThread detachNewThreadSelector:@selector(skeletonThreadMain) toTarget:weakSelf withObject:nil];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"运行运行循环").detailSet(@"启动运行循环。每次运行循环例程返回时，都检查是否出现了可能需要退出该线程的条件。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *model){
                model.titleSet(@"使用运行循环对象").detailSet(@"运行循环对象提供了用于将输入源，计时器和运行循环观察器添加到运行循环然后运行它的主界面。每个线程都有一个与之关联的运行循环对象。在Cocoa中，此对象是NSRunLoop类的实例。在低级应用程序中，它是指向CFRunLoopRef opaque类型的指针。");
            });
        }).addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(myDoFireTimer1:) userInfo:nil repeats:YES];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"NSTimer类方法创建并调度计时器").detailSet(@"创建计时器并在默认模式（NSDefaultRunLoopMode）中将其添加到当前线程的运行循环中。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:0.1 target:self selector:@selector(myDoFireTimer2:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"NSTimer手动调度计时器").detailSet(@"可以手动调度计时器，方法是创建NSTimer对象，然后使用addTimer:forMode:方法将其添加到运行循环中NSRunLoop。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    CFRunLoopRef rf = CFRunLoopGetCurrent();
                    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
                    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 0.3, 0, 0, &myCFTimerCallBack, &context);
                    CFRunLoopAddTimer(rf, timer, kCFRunLoopDefaultMode);
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"Core Foundation创建和调度计时器").detailSet(@"使用Core Foundation函数配置计时器，可以使用上下文结构传递计时器所需的任何自定义数据。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *model){
                model.titleSet(@"配置定时器源").detailSet(@"要创建计时器源，要做的就是创建一个计时器对象并在运行循环上调度。在Cocoa中，您使用NSTimer类创建新的计时器对象，在Core Foundation中使用CFRunLoopTimerRef opaque类型。");
            });
        });
    });
}

- (void)mainThread {
    //应用程序使用垃圾收集，因此不需要自动释放池。
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    
    //创建一个运行循环观察器并将其附加到运行循环。
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);

    if (observer) {
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    
    //创建并安排计时器。
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
    
    NSInteger loopCount = 10;
    do {
        //让计时器触发10次运行循环运行。
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        NSLog(@"+++++++++++++%lu", loopCount);
    } while (loopCount--);
}

void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSLog(@"-----------%s\nthread:%@\nobserver:%@\nactivity:%lu\ninfo:%@", __FUNCTION__, [NSThread currentThread], observer, activity, info);
}
- (void)doFireTimer:(NSTimer *)sender {
    NSLog(@"-----------%s\ntimer:%@", __FUNCTION__, sender);
}
- (void)doFireTimer2:(NSTimer *)sender {
    NSLog(@"-----------%s\ntimer:%@", __FUNCTION__, sender);
}

- (void)skeletonThreadMain {
    //如果不使用垃圾收集，在此处设置自动释放池
    bool down = NO;
    
    //将输入源或计时器添加到运行循环并执行任何其他设置。
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doFireTimer2:) userInfo:nil repeats:NO];
    
    do {
        //启动运行循环，但在处理完每个源后返回。
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
        
        //如果源显式停止了运行循环
        if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
            down = YES;
        
        NSLog(@"----------%s\nresult:%i", __FUNCTION__, result);
        //在这里检查任何其他退出条件并设置
        //根据需要完成变量
    } while (!down);
}
- (void)myDoFireTimer1:(NSTimer *)sender {
    NSLog(@"----------%s\nsender:%@", __FUNCTION__, sender);
}
- (void)myDoFireTimer2:(NSTimer *)sender {
    NSLog(@"----------%s\nsender:%@", __FUNCTION__, sender);
}

void myCFTimerCallBack(CFRunLoopTimerRef timer, void *info) {
    NSLog(@"---------%s\ntimer:%@\ninfo:%@", __FUNCTION__, timer, info);
}

- (void)launchThread {
    NSPort *myPort = [NSMachPort port];
    if (myPort) {
        //此类处理传入的端口消息
        [myPort setDelegate:self];
        
        //在当前运行循环中将端口安装为输入源
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        
        //分离线程,让工作线程释放端口
        [NSThread detachNewThreadSelector:@selector(luanchThreadWithPort:) toTarget:self withObject:myPort];
    }
}
- (void)storeDistancePort:(NSPort *)port {
    
}

+ (void)launchThreadWithPort:(id)inData {
    @autoreleasepool{
        //在此线程和主线程之间建立连接
        NSPort *distancePort = (NSPort *)inData;
        MainViewController *workObj = [[self alloc] init];
        [workObj sendCheckinMessage:distancePort];
        
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (![workObj shouldExit]);
    }
}
//工作线程签入方法
- (void)sendCheckinMessage:(NSPort *)outPort {
    //保留并保存远程端口以备将来使用
    [self setRemotePort:outPort];
    
    //创建并配置工作线程端口
    NSPort *myPort = [NSMachPort port];
    [myPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    
    //创建签入消息
    NSPortMessage *messageObj;
//    messageObj = [[NSPortMessage alloc] initWithSendPort:outPort receivePort:myPort components:nil];
    if (messageObj) {
//        [messageObj setMsgid:KCheckInMessage];
//        [messageObj sendBeforeDate[NSDate date]];
    }
}
- (BOOL)shouldExit {
    
    return NO;
}
- (void)setRemotePort:(NSPort *)port {
    
}

#pragma mark <NSPortDelegate>代理方法
#define KCheckInMessage         100
// 处理来自工作线程的响应
- (void)handlePortMessage:(NSPortMessage *)portMessage {
    id objMessage = portMessage;
    unsigned int messege = [[objMessage valueForKey:@"msgid"] unsignedIntValue];
    NSPort *distancePort = nil;
    if (messege == KCheckInMessage) {
        //获取工作线程的通信端口
        distancePort = [objMessage performSelector:@selector(sendPort)];
        
        //保留并保存工作端口以供以后使用
        [self storeDistancePort:distancePort];
    } else {
        //处理其他消息
    }
}

@end
