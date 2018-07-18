//
//  UITableViewSectionModel.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonSectionModel.h"
#import "CommonTableViewRowModel.h"

@interface CommonTableViewSectionModel : CommonSectionModel

typedef CommonTableViewSectionModel *(^UITableViewAddRowModelBlock)(CommonTableViewRowModel *rowModel);
typedef void (^UITableViewCreatSectionBlock)(CommonTableViewSectionModel *);
typedef void (^UITableViewCreateRowBlock)(CommonTableViewRowModel *);

@property (copy, nonatomic, readonly) NSString *titleV;
@property (copy, nonatomic, readonly) NSString *detailsV;
@property (assign, nonatomic, readonly) NSInteger rowCountV;
@property (assign, nonatomic, readonly) NSInteger sectionV;

- (CommonTableViewSectionModel * (^)(NSString *))title;
- (CommonTableViewSectionModel * (^)(NSString *))details;
- (CommonTableViewSectionModel * (^)(NSInteger))section;
- (CommonTableViewSectionModel * (^)(UITableViewCreateRowBlock))addRowModel;

- (CommonTableViewRowModel *)rowModelWithRow:(NSInteger)row;

@end
