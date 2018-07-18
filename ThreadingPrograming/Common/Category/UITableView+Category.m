//
//  UITableView+Category.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/18.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "UITableView+Category.h"
#import <objc/runtime.h>

#define K_Helper_Key        @"CommonTableViewHelper"

@implementation UITableView (Category)

- (CommonTableViewHelper *)helperV {
    return objc_getAssociatedObject(self, K_Helper_Key);
}

- (UITableView * (^)(CommonTableViewHelperBlock))helper {
    return ^(CommonTableViewHelperBlock block){
        CommonTableViewHelper *helper = [[CommonTableViewHelper alloc] init];
        if (block) {
            block(helper);
        }
        
        objc_setAssociatedObject(self, K_Helper_Key, helper, OBJC_ASSOCIATION_RETAIN);
        
        self.dataSource = helper;
        self.delegate = helper;
        
        return self;
    };
}

@end
