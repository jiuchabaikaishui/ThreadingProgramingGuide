//
//  RowModel.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/17.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "CommonRowModel.h"

@implementation CommonRowModel

- (void)setTitle:(NSString * __unused)title { MethodNotImplementedInSubclass(); }
- (void)setDetails:(NSString * __unused)details { MethodNotImplementedInSubclass(); }
- (void)setRow:(NSInteger __unused)row { MethodNotImplementedInSubclass(); }
- (void)setSelectedBlock:(RowModelSelectedBlock)selectedBlock { MethodNotImplementedInSubclass(); }

- (CommonRowModel * (^)(NSString *))title {
    return ^CommonRowModel *(NSString *title){
        self.title = title;
        
        return self;
    };
}
- (CommonRowModel * (^)(NSString *))details {
    return ^CommonRowModel *(NSString *details){
        self.details = details;
        
        return self;
    };
}
- (CommonRowModel * (^)(NSInteger))row {
    return ^CommonRowModel *(NSInteger row){
        self.row = row;
        
        return self;
    };
}
- (CommonRowModel * (^)(RowModelSelectedBlock))selectedBolck {
    return ^CommonRowModel *(RowModelSelectedBlock block) {
        self.selectedBlock = block;
        
        return self;
    };
}

@end
