//
//  UITableViewRowModel.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonRowModel.h"

@interface CommonTableViewRowModel : NSObject

typedef void (^UITableViewRowSelectedBlock)(UITableView *tableView, NSIndexPath *indexPath);

@property (copy, nonatomic, readonly) NSString *titleV;
@property (copy, nonatomic, readonly) NSString *detailsV;
@property (assign, nonatomic, readonly) NSInteger rowV;
@property (copy, nonatomic, readonly) UITableViewRowSelectedBlock selectedBlockV;

- (CommonTableViewRowModel * (^)(NSString *))title;
- (CommonTableViewRowModel * (^)(NSString *))details;
- (CommonTableViewRowModel * (^)(NSInteger))row;
- (CommonTableViewRowModel * (^)(UITableViewRowSelectedBlock))selectedBolck;

@end
