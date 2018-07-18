//
//  UITableViewModel.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "CommonTableViewModel.h"

@interface CommonTableViewModel ()

@property (strong, nonatomic) NSMutableArray *sectionModels;

@end

@implementation CommonTableViewModel

- (NSMutableArray *)sectionModels {
    if (_sectionModels == nil) {
        _sectionModels = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _sectionModels;
}
- (NSInteger)sectionCountV {
    return self.sectionModels.count;
}

+ (instancetype)createModel:(void (^)(CommonTableViewModel *model))block {
    CommonTableViewModel *model = [[CommonTableViewModel alloc] init];
    if (block) {
        block(model);
    }
    return model;
}
- (instancetype (^)(UITableViewCreatSectionBlock))addSectionModel {
    return ^CommonTableViewModel * (UITableViewCreatSectionBlock block){
        CommonTableViewSectionModel *sectionModel = [[CommonTableViewSectionModel alloc] init];
        if (block) {
            block(sectionModel);
        }
        [self.sectionModels addObject:sectionModel];
        
        return self;
    };
}
- (CommonTableViewSectionModel *)sectionModelWithSection:(NSInteger)section {
    return [self.sectionModels objectAtIndex:section];
}
- (CommonTableViewRowModel *)rowModelWithIndexPath:(NSIndexPath *)indexPath {
    return [[self.sectionModels objectAtIndex:indexPath.section] rowModelWithRow:indexPath.row];
}

@end
