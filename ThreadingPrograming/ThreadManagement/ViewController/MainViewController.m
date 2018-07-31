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
    self.title = @"线程编程";
    self.tableView.vmCreate(^(QSPTableViewVM *vm){
        vm.addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
            sectionVM.addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [weakSelf performSegueWithIdentifier:@"MainToThreadManagement" sender:[tableView cellForRowAtIndexPath:indexPath]];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"线程管理").detailSet(@"在OS X和iOS系统中每个进程（应用程序）都有一个或者多个线程构成，每个线程表示着执行应用程序代码的单个路径。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [weakSelf performSegueWithIdentifier:@"MainToRunloop" sender:[tableView cellForRowAtIndexPath:indexPath]];
                }).dataMCreate(CommonM.class, ^(CommonM *model){
                    model.titleSet(@"运行循环").detailSet(@"运行循环是与线程相关的基础架构的一部分。一个运行循环是指用于安排工作，并协调接收传入事件的事件处理循环。运行循环的目的是在有任务时保持线程忙，并在没有任务时让线程进入休眠状态。");
                });
            });
        });
    });
}

@end
