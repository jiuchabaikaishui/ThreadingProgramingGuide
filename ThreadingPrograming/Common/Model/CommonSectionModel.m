//
//  SectionModel.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "CommonSectionModel.h"

@implementation CommonSectionModel

//typedef void (^RowModelBlock)(RowModel *rowModel);

- (void)setTitle:(NSString * __unused)title { MethodNotImplementedInSubclass(); }
- (void)setDetails:(NSString * __unused)details { MethodNotImplementedInSubclass(); }
- (void)setSection:(NSInteger __unused)section { MethodNotImplementedInSubclass(); }
- (void)setAddRowModel:(CommonRowModel * __unused)block { MethodNotImplementedInSubclass(); }

- (CommonSectionModel * (^)(NSString *))title {
    return ^(NSString *strValue){
        self.title = strValue;
        
        return self;
    };
}
- (CommonSectionModel * (^)(NSString *))details {
    return ^CommonSectionModel *(NSString *details){
        self.details = details;
        
        return self;
    };
}
- (CommonSectionModel * (^)(NSInteger))section {
    return ^CommonSectionModel *(NSInteger section){
        self.section = section;
        
        return self;
    };
}
- (CommonSectionModel * (^)(SectionModelCreateBlock))addRowModel {
    return ^CommonSectionModel *(SectionModelCreateBlock block){
        CommonRowModel *rowModel = [[CommonRowModel alloc] init];
        if (block) {
            block(rowModel);
        }
        self.addRowModel = rowModel;
        
        return self;
    };
}

@end
