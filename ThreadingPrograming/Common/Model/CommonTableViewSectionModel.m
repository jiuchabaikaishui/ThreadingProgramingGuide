//
//  UITableViewSectionModel.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "CommonTableViewSectionModel.h"

@interface CommonTableViewSectionModel ()

@property (strong, nonatomic) NSMutableArray *rowModels;

@end

@implementation CommonTableViewSectionModel

- (NSMutableArray *)rowModels {
    if (_rowModels == nil) {
        _rowModels = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _rowModels;
}
- (void)setTitle:(NSString *)title {
    _titleV = [title copy];
}
- (void)setDetails:(NSString *)details {
    _detailsV = [details copy];
}
- (void)setSection:(NSInteger)section {
    _sectionV = section;
}
- (CommonTableViewSectionModel * (^)(NSString *))title {
    return ^(NSString *strValue){
        self.title = strValue;
        
        return self;
    };
}
- (CommonTableViewSectionModel * (^)(NSString *))details {
    return ^(NSString *details){
        self.details = details;
        
        return self;
    };
}
- (CommonTableViewSectionModel * (^)(NSInteger))section {
    return ^(NSInteger section){
        self.section = section;
        
        return self;
    };
}
- (CommonTableViewSectionModel * (^)(UITableViewCreateRowBlock))addRowModel {
    return ^(UITableViewCreateRowBlock block){
        CommonTableViewRowModel *rowModel = [[CommonTableViewRowModel alloc] init];
        if (block) {
            block(rowModel);
        }
        self.addRowModel = rowModel;
        
        return self;
    };
}

- (NSInteger)rowCountV {
    return self.rowModels.count;
}
- (void)setAddRowModel:(CommonTableViewRowModel *)rowModel {
    [self.rowModels addObject:rowModel];
}

- (CommonTableViewRowModel *)rowModelWithRow:(NSInteger)row {
    return [self.rowModels objectAtIndex:row];
}

@end
