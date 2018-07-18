//
//  CommonTableViewHelper.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/18.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonTableViewModel.h"
#import <UIKit/UIKit.h>

typedef void (^CommonTableViewModelBlock)(CommonTableViewModel *);

@interface CommonTableViewHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readonly) CommonTableViewModel *tableViewModelV;

- (CommonTableViewHelper * (^)(CommonTableViewModelBlock))tableViewModel;

@end
