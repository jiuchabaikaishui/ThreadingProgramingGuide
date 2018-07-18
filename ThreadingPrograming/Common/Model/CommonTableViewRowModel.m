//
//  UITableViewRowModel.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "CommonTableViewRowModel.h"

@implementation CommonTableViewRowModel

- (void)setTitle:(NSString *)title {
    _titleV = [title copy];
}
- (void)setDetails:(NSString *)details {
    _detailsV = [details copy];
}
- (void)setRow:(NSInteger)row {
    _rowV = row;
}
- (void)setSelectedBlock:(UITableViewRowSelectedBlock)selectedBlock {
    _selectedBlockV = [selectedBlock copy];
}

- (CommonTableViewRowModel * (^)(NSString *))title {
    return ^(NSString *title){
        self.title = title;
        
        return self;
    };
}
- (CommonTableViewRowModel * (^)(NSString *))details {
    return ^(NSString *details){
        self.details = details;
        
        return self;
    };
}
- (CommonTableViewRowModel * (^)(NSInteger))row {
    return ^(NSInteger row){
        self.row = row;
        
        return self;
    };
}
- (CommonTableViewRowModel * (^)(UITableViewRowSelectedBlock))selectedBolck {
    return ^(UITableViewRowSelectedBlock block) {
        self.selectedBlock = block;
        
        return self;
    };
}

@end
