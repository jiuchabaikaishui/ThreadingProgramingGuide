//
//  UITableView+QSPMVVM.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/20.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "UITableView+QSPMVVM.h"
#import <objc/runtime.h>

#define K_QSPMVVMTableViewVM_Key        @"QSPMVVMTableViewVMKey"

@implementation UITableView (QSPMVVM)

- (QSPTableViewVM *)vm {
    return objc_getAssociatedObject(self, K_QSPMVVMTableViewVM_Key);
}

- (UITableView * (^)(QSPMVVMSetTableViewVMBlock))vmCreate {
    return ^(QSPMVVMSetTableViewVMBlock block){
        QSPTableViewVM *vm = [[QSPTableViewVM alloc] init];
        if (block) {
            block(vm);
        }
        
        objc_setAssociatedObject(self, K_QSPMVVMTableViewVM_Key, vm, OBJC_ASSOCIATION_RETAIN);
        
        self.dataSource = vm;
        self.delegate = vm;
        self.tableHeaderView = vm.tableHeaderView;
        self.tableFooterView = vm.tableFooterView;
        
        return self;
    };
}

@end
