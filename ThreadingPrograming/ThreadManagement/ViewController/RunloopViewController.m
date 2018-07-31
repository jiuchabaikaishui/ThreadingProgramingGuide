//
//  RunloopViewController.m
//  ThreadManagement
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "RunloopViewController.h"
#import "CommonDefine.h"

@interface RunloopViewController ()

@property (weak,nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Runloop";
    self.tableView.vmCreate(^(QSPTableViewVM *vm){
        
    });
}

- (void)threadMain{
    //应用程序使用垃圾回收，因此不需要自动释放池
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    
    //创建一个运行循环观察器并将其附加到运行循环。
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL};
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
}

@end
