//
//  MainViewController.m
//  ThreadManagement
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "MainViewController.h"
#import "UITableView+QSPMVVM.h"
#import "CommonTableViewSectionVM.h"
#import "CommonTableViewHeaderView.h"
#import "CommonTableViewCellVM.h"
#import "CommonTableViewCell.h"

#define K_WeakSelf          __weak typeof(self) weakSelf = self;

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
                    [NSThread detachNewThreadSelector:@selector(myThreadMainMethod:) toTarget:weakSelf withObject:nil];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"类方法选择器方式").detailSet(@"使用detachNewThreadSelector:toTarget:withObject:类方法生成新线程。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    [NSThread detachNewThreadWithBlock:^{
                        [weakSelf myThreadMainMethod:nil];
                    }];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"类方法block方式").detailSet(@"使用detachNewThreadWithBlock:类方法生成新线程。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadMainMethod:) object:nil];
                    [thread start];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"实例方法选择器方式").detailSet(@"使用选择器方式创建一个新的NSThread对象并调用其start方法。");
                });
            }).addRowVMCreate(CommonTableViewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                    NSThread *thread = [[NSThread alloc] initWithBlock:^{
                        [weakSelf myThreadMainMethod:nil];
                    }];
                    [thread start];
                }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                    commonM.titleSet(@"实例方法block方式").detailSet(@"使用block方式创建一个新的NSThread对象并调用其start方法。");
                });
            }).dataMCreate(CommonM.class, ^(CommonM *commonM){
                commonM.titleSet(@"NSThread创建线程NSThread创建线程NSThread创建线程NSThread创建线程").detailSet(@"NSThread类可以使用类方法生成新线程或者创建一个新的NSThread对象并调用其start方法。");
            });
        });
    });
}

- (void)myThreadMainMethod:(id)object {
    NSLog(@"\n----%s, Thread:%@", __FUNCTION__, [NSThread currentThread]);
}

@end
