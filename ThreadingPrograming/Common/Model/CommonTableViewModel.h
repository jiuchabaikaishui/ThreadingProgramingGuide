//
//  UITableViewModel.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonTableViewSectionModel.h"

@interface CommonTableViewModel : NSObject

@property (assign, nonatomic, readonly) NSInteger sectionCountV;

+ (instancetype)createModel:(void (^)(CommonTableViewModel *model))block;
- (instancetype (^)(UITableViewCreatSectionBlock))addSectionModel;

- (CommonTableViewSectionModel *)sectionModelWithSection:(NSInteger)section;
- (CommonTableViewRowModel *)rowModelWithIndexPath:(NSIndexPath *)indexPath;

@end
