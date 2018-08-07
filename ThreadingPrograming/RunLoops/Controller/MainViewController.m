//
//  MainViewController.m
//  RunLoops
//
//  Created by QSP on 2018/7/31.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "MainViewController.h"
#import "CommonDefine.h"
#import "RunLoopSource.h"

#define KCheckInMathPortMessage                 100
#define KCheckOutMathPortMessage                101
#define KCheckInMessagePortMessage              103
#define KCheckOutMessagePortMessage             104
#define KMainMessagePortName                    "com.myapp.MainThread"
#define KWorkMessagePortName                    "com.MyApp.Thread"

@interface MainViewController ()<NSPortDelegate, RunLoopSourceDelegate> {
    CFMessagePortRef mainMessagePort;
    CFMessagePortRef workMessagePort;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) RunLoopSource *source;
@property (strong, nonatomic) NSPort *mainPort;
@property (strong, nonatomic) NSPort *workPort;
//@property (strong, nonatomic) NSPort *mainMessagePort;
//@property (strong, nonatomic) NSPort *workMessagePort;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self launchCostomPortThread];
    [self launchThread];
//    [self launchMessagePortThread];
    [self mySpawnThread];
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
                    [weakSelf.source addCommand:0 withData:@"发消息啦"];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"配置自定义输入源").detailSet(@"应用程序的主线程维护对输入源的引用，该输入源的自定义命令缓冲区以及安装输入源的运行循环。当主线程有一个要传递给工作线程的任务时，它会向命令缓冲区发布一个命令以及工作线程启动任务所需的任何信息。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *model){
                model.titleSet(@"自定义输入源").detailSet(@"创建了一个自定义输入源来处理自定义信息，实际配置的设计非常灵活。调度程序，处理程序和取消例程是您自定义输入源几乎总是需要的关键例程。");
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
        }).addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    if (weakSelf.workPort) {
                        [weakSelf.workPort sendBeforeDate:[NSDate date] msgid:KCheckOutMathPortMessage components:nil from:weakSelf.mainPort reserved:0];
                    } else {
                        [weakSelf launchThread];
                    }
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"配置NSMachPort对象").detailSet(@"要与NSMachPort对象建立本地连接，需创建端口对象并将其添加到主线程的运行循环中，然后在启动辅助线程时，将同一端口对象传递给辅助线程的入口点函数，辅助线程可以使用相同的端口对象将消息发送回主线程。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"配置NSMessagePort对象（iOS中不支持）").detailSet(@"要与NSMessagePort对象建立本地连接，不能简单地在线程之间传递端口对象。必须按名称获取远程消息端口。在Cocoa中实现这一点需要使用特定名称注册本地端口，然后将该名称传递给远程线程，以便它可以获取适当的端口对象进行通信。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    NSString *msg = @"我的消息";
                    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
                    CFMessagePortRef workPort = CFMessagePortCreateRemote(NULL, CFSTR(KWorkMessagePortName));
                    CFMessagePortSendRequest(workPort, KCheckOutMessagePortMessage, (__bridge_retained CFDataRef)msgData, 0, 0, NULL, NULL);
                    CFRelease(workPort);
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"Core Foundation中配置基于端口的输入源").detailSet(@"使用Core Foundation在应用程序的主线程和工作线程之间建立双向通信通道。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *model){
                model.titleSet(@"配置基于端口的输入源").detailSet(@"Cocoa和Core Foundation都提供了基于端口的对象，用于线程之间或进程之间的通信。");
            });
        });
    });
}


#pragma mark - 创建运行循环观察器
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
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
    
//    [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    CFRunLoopRunResult result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, YES);
    NSLog(@"+++++++++++++%s\nNSThread:%@\nresult:%i", __FUNCTION__, [NSThread currentThread], result);
//    NSInteger loopCount = 10;
//    do {
//        //让计时器触发10次运行循环运行。
//        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//        NSLog(@"+++++++++++++%lu", loopCount);
//    } while (loopCount--);
}
void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSString *str = @"";
    switch (activity) {
        case kCFRunLoopEntry:
            str = @"kCFRunLoopEntry";
            break;
        case kCFRunLoopBeforeTimers:
            str = @"kCFRunLoopBeforeTimers";
            break;
        case kCFRunLoopBeforeSources:
            str = @"kCFRunLoopBeforeSources";
            break;
        case kCFRunLoopBeforeWaiting:
            str = @"kCFRunLoopBeforeWaiting";
            break;
        case kCFRunLoopAfterWaiting:
            str = @"kCFRunLoopAfterWaiting";
            break;
        case kCFRunLoopExit:
            str = @"kCFRunLoopExit";
            break;
        case kCFRunLoopAllActivities:
            str = @"kCFRunLoopAllActivities";
            break;
            
        default:
            break;
    }
    NSLog(@"-----------%s\nthread:%@\nobserver:%@\nactivity:%lu     %@\ninfo:%@", __FUNCTION__, [NSThread currentThread], observer, activity, str, info);
}
- (void)doFireTimer:(NSTimer *)sender {
    NSLog(@"-----------%s\ntimer:%@", __FUNCTION__, sender);
}


#pragma mark - 运行运行循环
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


#pragma mark - 配置定时器源
- (void)myDoFireTimer1:(NSTimer *)sender {
    NSLog(@"----------%s\nsender:%@", __FUNCTION__, sender);
}
- (void)myDoFireTimer2:(NSTimer *)sender {
    NSLog(@"----------%s\nsender:%@", __FUNCTION__, sender);
}

void myCFTimerCallBack(CFRunLoopTimerRef timer, void *info) {
    NSLog(@"---------%s\ntimer:%@\ninfo:%@", __FUNCTION__, timer, info);
}


#pragma mark - 自定义输入源
- (void)launchCostomPortThread {
    [NSThread detachNewThreadSelector:@selector(costomPortThread:) toTarget:self withObject:nil];
}
- (void)costomPortThread:(id)obj {
    @autoreleasepool {
        RunLoopSource *source = [[RunLoopSource alloc] init];
        source.delegate = self;
        [source addToCurrentRunLoop];
        self.source = source;
        [[NSRunLoop currentRunLoop] run];
    };
}

#pragma mark <RunLoopSourceDelegate>代理方法
- (void)registerSource:(RunLoopContext *)sourceContext {
    NSLog(@"------------%s\ncontext:%@", __FUNCTION__, sourceContext);
}
- (void)removeSource:(RunLoopContext *)sourceContext {
    NSLog(@"------------%s\ncontext:%@", __FUNCTION__, sourceContext);
}


#pragma mark - 配置NSMachPort端口
- (void)launchThread {
    NSPort *myPort = [NSMachPort port];
    if (myPort) {
        //此类处理传入的端口消息
        [myPort setDelegate:self];
        
        //在当前运行循环中将端口安装为输入源
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        self.mainPort = myPort;
        
        //分离线程,让工作线程释放端口
        [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:) toTarget:self withObject:myPort];
    }
}
- (void)launchThreadWithPort:(id)inData {
    @autoreleasepool{
        //在此线程和主线程之间建立连接
        NSPort *distancePort = (NSPort *)inData;
        [self sendCheckinMessage:distancePort];
        
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (![self shouldExit]);
    }
}
//工作线程签入方法
- (void)sendCheckinMessage:(NSPort *)outPort {
    //保留并保存远程端口以备将来使用
//    [self setRemotePort:outPort];
    
    //创建并配置工作线程端口
    NSPort *myPort = [NSMachPort port];
    [myPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    self.workPort = myPort;
    
    //创建签入消息
//    NSPortMessage *messageObj;
//    messageObj = [[NSPortMessage alloc] initWithSendPort:outPort receivePort:myPort components:nil];
//    if (messageObj) {
//        // 完成消息配置并立即发送
//        [messageObj setMsgid:KCheckInMessage];
//        [messageObj sendBeforeDate[NSDate date]];
//    }
    
//    if (outPort) {
//        [outPort sendBeforeDate:[NSDate date] msgid:KCheckInMathPortMessage components:nil from:myPort reserved:0];
//    }
}
- (BOOL)shouldExit {
    
    return NO;
}
- (void)setRemotePort:(NSPort *)port {
    
}
- (void)storeDistancePort:(NSPort *)port {
    
}

#pragma mark <NSPortDelegate>代理方法
// 处理来自工作线程的响应
- (void)handlePortMessage:(NSPortMessage *)portMessage {
    id objMessage = portMessage;
    unsigned int messege = [[objMessage valueForKey:@"msgid"] unsignedIntValue];
    NSPort *distancePort = [objMessage performSelector:@selector(sendPort)];
    NSLog(@"------------%s\nthread:%@\nportMessage:%@\ndiatancePort:%@", __FUNCTION__, [NSThread currentThread], portMessage, distancePort);
    if (messege == KCheckInMathPortMessage) {
        //        //获取工作线程的通信端口
        //        distancePort = [objMessage performSelector:@selector(sendPort)];
        //
        //        //保留并保存工作端口以供以后使用
        //        [self storeDistancePort:distancePort];
        //
        //        NSLog(@"------------%s\nthread:%@\nportMessage:%@\ndiatancePort:%@", __FUNCTION__, [NSThread currentThread], portMessage, distancePort);
    } else {
        //处理其他消息
    }
}


#pragma mark - 配置NSMessagePort端口
//- (void)launchMessagePortThread {
//    NSMessagePort *port = (NSMessagePort *)[NSMessagePort port];
//    [port setDelegate:self];
//    CFMessagePortSetName((__bridge_retained CFMessagePortRef)port, CFSTR(KMainMessagePortName));
//    if (port) {
//        [[NSRunLoop currentRunLoop] addPort:port forMode:NSDefaultRunLoopMode];
//        self.mainMessagePort = port;
//
//        [NSThread detachNewThreadSelector:@selector(launchThreadWithMessagePort:) toTarget:self withObject:port];
//    }
//}
//- (void)launchThreadWithMessagePort:(NSMessagePort *)messagePort {
//    @autoreleasepool{
//        NSMessagePort *messagePort = (NSMessagePort *)[NSMessagePort port];
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        [runLoop addPort:messagePort forMode:NSDefaultRunLoopMode];
//        self.workMessagePort = messagePort;
//
//        do {
//            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        } while (![self messagePortShouldExit]);
//    };
//}
//- (BOOL)messagePortShouldExit {
//
//    return NO;
//}


#pragma mark - Core Foundation中配置基于端口的输入源
- (OSStatus)mySpawnThread {
    // 创建用于接收响应的本地端口
    CFStringRef myPortName;
    CFMessagePortRef myPort;
    CFRunLoopSourceRef rlSource;
    CFMessagePortContext context = {0, NULL, NULL, NULL, NULL};
    Boolean shouldFreeInfo;
    
    // 创建一个包含端口名称的字符串
    myPortName = CFStringCreateWithFormat(NULL, NULL, CFSTR(KMainMessagePortName));
    // 创建端口
    myPort = CFMessagePortCreateLocal(NULL, myPortName, &mainThreadResponseHandler, &context, &shouldFreeInfo);
    
    if (myPort != NULL) {
        // 端口已成功创建。
        // 现在为它创建一个运行循环源
        rlSource = CFMessagePortCreateRunLoopSource(NULL, myPort, 0);
        
        if (rlSource) {
            // 将源添加到当前端口
            CFRunLoopAddSource(CFRunLoopGetCurrent(), rlSource, kCFRunLoopDefaultMode);
            
            // 一但安装，可以释放这些
            CFRelease(myPort);
            CFRelease(rlSource);
        }
    }
    
    // 创建线程
    [NSThread detachNewThreadSelector:@selector(spawnMessagePortThread:) toTarget:self withObject:(__bridge_transfer id)myPortName];
    
//    MPTaskID        taskID;
//    return(MPCreateTask(&ServerThreadEntryPoint,
//                        (void*)myPortName,
//                        kThreadStackSize,
//                        NULL,
//                        NULL,
//                        NULL,
//                        0,
//                        &taskID));
    
    return 0;
}
//主线程端口消息处理程序
CFDataRef mainThreadResponseHandler(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info) {
    if (msgid == KCheckInMessagePortMessage) {
        CFMessagePortRef messagePort;
        CFStringRef threadPortName;
        CFIndex bufferLength = CFDataGetLength(data);
        
        UInt8 *buffer = CFAllocatorAllocate(NULL, bufferLength, 0);
        CFDataGetBytes(data, CFRangeMake(0, bufferLength), buffer);
        threadPortName = CFStringCreateWithBytes(NULL, buffer, bufferLength, kCFStringEncodingUTF8, false);
        
        //必须按名称获取远程消息端口
        messagePort = CFMessagePortCreateRemote(NULL, threadPortName);
        
        if (messagePort) {
            //保留并保存线程的通信端口以供将来参考
//            AddPortToListOfActiveThreads(messagePort);
            
            //由于前一个函数保留了端口，因此请释放
            CFRelease(messagePort);
        }
        
        CFRelease(threadPortName);
        CFAllocatorDeallocate(NULL, buffer);
    } else {
        //处理其他消息
    }
    
    return NULL;
}
- (OSStatus)spawnMessagePortThread:(id)name {
    // 创建来自主线程的远程端口
    CFStringRef portName = (__bridge_retained CFStringRef)name;
    CFMessagePortRef mainThreadPort = CFMessagePortCreateRemote(NULL, portName);
    
    // 保存端口到本线程的context中以便以后使用
    CFMessagePortContext context = {0, mainThreadPort, NULL, NULL, NULL};
    
    // 为工作线程创建端口
    Boolean shouldFreeInfo;
    CFStringRef myPortName = CFStringCreateWithFormat(NULL, NULL, CFSTR(KWorkMessagePortName));
    CFMessagePortRef myPort = CFMessagePortCreateLocal(NULL, myPortName, &processClientRequest, &context, &shouldFreeInfo);
    
    if (shouldFreeInfo) {
        // 不能创建本地端口，杀掉线程
        [NSThread exit];
    }
    
    CFRunLoopSourceRef rlSource = CFMessagePortCreateRunLoopSource(NULL, myPort, 0);
    if (!rlSource) {
        // 不能创建本地端口，杀掉线程
        [NSThread exit];
    }
    
    // 为当前线程添加输入源
    CFRunLoopAddSource(CFRunLoopGetCurrent(), rlSource, kCFRunLoopDefaultMode);
    
    // 一但安装，可以释放这些
    CFRelease(myPort);
    CFRelease(rlSource);
    
    // 打包端口名称并发送签入消息
//    CFDataRef returnData = nil;
    CFIndex stringLength = CFStringGetLength(myPortName);
    UInt8 *buffer = CFAllocatorAllocate(NULL, stringLength, 0);
    CFStringGetBytes(myPortName, CFRangeMake(0, stringLength), kCFStringEncodingASCII, 0, false, buffer, stringLength, NULL);
    CFDataRef outData = CFDataCreate(NULL, buffer, stringLength);
    
    CFMessagePortSendRequest(mainThreadPort, KCheckInMessagePortMessage, outData, 0.1, 0, NULL, NULL);
    
    // 清理线程数据
    CFRelease(outData);
    CFRelease(portName);
    CFRelease(myPortName);
    CFRelease(mainThreadPort);
    CFAllocatorDeallocate(NULL, buffer);
    
    // 运行运行循环
    CFRunLoopRun();
    
    return 0;
}
CFDataRef processClientRequest(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info) {
    // 把data转为字符串
    NSString *msg = [[NSString alloc] initWithData:(__bridge NSData *)data encoding:NSUTF8StringEncoding];
    NSLog(@"----------%s\nthread:%@\ndata:%@", __FUNCTION__, [NSThread currentThread], msg);
    
    if (msgid == KCheckOutMessagePortMessage) {
        // 端口名称
        CFStringRef threadPortName = CFSTR(KMainMessagePortName);
        
        //必须按名称获取远程消息端口
        CFMessagePortRef messagePort = CFMessagePortCreateRemote(NULL, threadPortName);
        
        if (messagePort) {
            //保留并保存线程的通信端口以供将来参考
            //            AddPortToListOfActiveThreads(messagePort);
            
            //由于前一个函数保留了端口，因此请释放
            CFRelease(messagePort);
        }
        
        CFRelease(threadPortName);
    } else {
        //处理其他消息
    }
    
    return NULL;
}

@end
