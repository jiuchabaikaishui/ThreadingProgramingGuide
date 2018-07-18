//
//  UITableView+Category.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/18.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewHelper.h"

typedef void (^CommonTableViewHelperBlock)(CommonTableViewHelper *);

@interface UITableView (Category)

@property (strong, nonatomic, readonly) CommonTableViewHelper *helperV;

- (UITableView * (^)(CommonTableViewHelperBlock))helper;

@end
