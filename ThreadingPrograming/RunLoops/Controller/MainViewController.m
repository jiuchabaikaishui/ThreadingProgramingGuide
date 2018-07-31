//
//  MainViewController.m
//  RunLoops
//
//  Created by QSP on 2018/7/31.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "MainViewController.h"
#import "CommonDefine.h"

@interface MainViewController ()

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

@end
