//
//  MainViewController.m
//  ThreadManagement
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "MainViewController.h"
#import "CommonDefine.h"
#import <pthread.h>

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    K_WeakSelf
    self.title = @"线程管理";
    self.tableView.vmCreate(^(QSPTableViewVM *vm){
        vm.addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [NSThread detachNewThreadSelector:@selector(myThreadMainMethod:) toTarget:weakSelf withObject:@"类方法选择器方式创建线程"];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"类方法选择器方式").detailSet(@"使用detachNewThreadSelector:toTarget:withObject:类方法生成新线程。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [NSThread detachNewThreadWithBlock:^{
                        [weakSelf myThreadMainMethod:@"类方法block方式创建线程"];
                    }];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"类方法block方式（iOS10.0之后可用）").detailSet(@"使用detachNewThreadWithBlock:类方法生成新线程。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadMainMethod:) object:@"实例方法选择器方式创建线程"];
                    [thread start];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"实例方法选择器方式").detailSet(@"使用选择器方式创建一个新的NSThread对象并调用其start方法。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    NSThread *thread = [[NSThread alloc] initWithBlock:^{
                        [weakSelf myThreadMainMethod:@"实例方法block方式创建线程"];
                    }];
                    [thread start];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"实例方法block方式（iOS10.0之后可用）").detailSet(@"使用block方式创建一个新的NSThread对象并调用其start方法。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                commonM.titleSet(@"NSThread创建线程").detailSet(@"NSThread类可以使用类方法生成新线程或者创建一个新的NSThread对象并调用其start方法。");
            });
        }).addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    launchThread(@"pthread_create函数创建线程");
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"函数调用方式").detailSet(@"调用pthread_create创建线程，更改线程的属性以创建分离线程。分离线程使系统有机会在退出时立即回收该线程的资源。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                commonM.titleSet(@"POSIX创建线程").detailSet(@"POSIX线程提供基于C的支持，跨平台更方便。");
            });
        }).addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [weakSelf performSelectorInBackground:@selector(myThreadMainMethod:) withObject:@"performSelectorInBackground:withObject:方法生成线程"];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"实例生成线程").detailSet(@"performSelectorInBackground:withObject:方法创建一个新的分离线程，并使用指定的方法作为新线程的入口点。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                commonM.titleSet(@"NSObject生成线程").detailSet(@"在iOS和OS X v10.5及更高版本中，所有对象都能够生成新线程并使用它来执行一个方法。");
            });
        }).addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [weakSelf myThreadMainRoutine:@"创建自动释放池"];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"创建自动释放池").detailSet(@"如果您的应用程序使用托管内存模型，那么创建自动释放池应该是在线程入口中首先要做的事情。同样，销毁这个自动释放池应该是在线程中做的最后一件事。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [NSThread detachNewThreadSelector:@selector(threadMainRoutine) toTarget:weakSelf withObject:nil];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"终止线程").detailSet(@"使用运行循环输入源来退出线程，只有线程主入口例程中的外观结构，不包括设置自动释放池或配置要执行的实际工作的步骤。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                commonM.titleSet(@"编写线程入口").detailSet(@"根据设计，在编写入口时可能需要执行一些额外的步骤。");
            });
        });
    });
}

- (void)myThreadMainMethod:(id)object {
    NSLog(@"----\nfunction:%s\nThread:%@\ndata:%@", __FUNCTION__, [NSThread currentThread], object);
}


void *posixThreadMainOutine(void *data) {
    //在这做一些工作
    NSLog(@"----\nfunction:%s\nThread:%@\ndata:%@", __FUNCTION__, [NSThread currentThread], data);
    
    return NULL;
}
void launchThread(void *data) {
    //使用POSIX例程创建线程
    pthread_attr_t attr;
    pthread_t posixThreadID;
    int returnVal;
    
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
    
    int threadError = pthread_create(&posixThreadID, &attr, posixThreadMainOutine, data);
    
    returnVal = pthread_attr_destroy(&attr);
    assert(!returnVal);
    if (threadError != 0) {
        //抛出错误
        
    }
}

- (void)myThreadMainRoutine:(id)object {
    @autoreleasepool {//顶级池
        NSLog(@"----\nfunction:%s\ndata:%@", __FUNCTION__, object);//线程在这里工作
    }//释放池中的对象
}

- (void)threadMainRoutine {
    BOOL moreWorkToDo = YES;
    BOOL exitNow = NO;
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    //将exitNow BOOL添加到线程字典中
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    [threadDict setValue:[NSNumber numberWithBool:exitNow] forKey:@"ThreadShouldExitNow"];
    
    //安装输入源
    [self myInstallCustomInputSource];
    
    while (moreWorkToDo && (!exitNow)) {
        //在这里做一大部分工作
        //完成后更改moreWorkToDo布尔值。
        moreWorkToDo = NO;
        
        //如果输入源没有等待触发，则runLoop立即超时
        [runLoop runUntilDate:[NSDate date]];
        
        //检查输入源处理程序是否更改了exitNow值
        exitNow = [[threadDict valueForKey:@"ThreadShouldExitNow"] boolValue];
        NSLog(@"-----------%s\nexitNow:%i", __FUNCTION__, exitNow);
    }
}
- (void)myInstallCustomInputSource {
    //创建并安排计时器。
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(doFireTimer:) userInfo:nil repeats:NO];
}
- (void)doFireTimer:(NSTimer *)sender {
    NSLog(@"-----------%s\ntimer:%@", __FUNCTION__, sender);
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    [threadDict setValue:[NSNumber numberWithBool:YES] forKey:@"ThreadShouldExitNow"];
}

@end
