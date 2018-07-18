//
//  MainViewController.m
//  ThreadManagement
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "MainViewController.h"
#import "CommonTableViewModel.h"
#import "UITableView+Category.h"

#define K_WeakSelf          __weak typeof(self) weakSelf = self;

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CommonTableViewModel *model;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"线程编程";
    K_WeakSelf
    self.tableView.helper(^(CommonTableViewHelper *helper){
        helper.tableViewModel(^(CommonTableViewModel *model){
            model.addSectionModel(^(CommonTableViewSectionModel *sectionModel){
                sectionModel.title(@"NSThread创建线程").details(@"NSThread类可以使用类方法生成新线程或者创建一个新的NSThread对象并调用其start方法。");
                sectionModel.addRowModel(^(CommonTableViewRowModel *rowModel){
                    rowModel.title(@"类方法选择器方式").details(@"使用detachNewThreadSelector:toTarget:withObject:类方法生成新线程。");
                    rowModel.selectedBolck(^(UITableView *tableView, NSIndexPath *indexPath){
                        [NSThread detachNewThreadSelector:@selector(myThreadMainMethod:) toTarget:weakSelf withObject:nil];
                    });
                });
                sectionModel.addRowModel(^(CommonTableViewRowModel *rowModel){
                    rowModel.title(@"类方法block方式").details(@"使用detachNewThreadWithBlock:类方法生成新线程。").selectedBolck(^(UITableView *tableView, NSIndexPath *indexPath){
                        [NSThread detachNewThreadWithBlock:^{
                            [weakSelf myThreadMainMethod:nil];
                        }];
                    });
                });
                sectionModel.addRowModel(^(CommonTableViewRowModel *rowModel){
                    rowModel.title(@"实例方法选择器方式").details(@"使用选择器方式创建一个新的NSThread对象并调用其start方法。").selectedBolck(^(UITableView *tableView, NSIndexPath *indexPath){
                        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadMainMethod:) object:nil];
                        [thread start];
                    });
                });
                sectionModel.addRowModel(^(CommonTableViewRowModel *rowModel){
                    rowModel.title(@"实例方法block方式").details(@"使用block方式创建一个新的NSThread对象并调用其start方法。").selectedBolck(^(UITableView *tableView, NSIndexPath *indexPath){
                        NSThread *thread = [[NSThread alloc] initWithBlock:^{
                            [weakSelf myThreadMainMethod:nil];
                        }];
                        [thread start];
                    });
                });
            });
        });
    });
}

- (void)myThreadMainMethod:(id)object {
    NSLog(@"\n----%s, Thread:%@", __FUNCTION__, [NSThread currentThread]);
}

@end
