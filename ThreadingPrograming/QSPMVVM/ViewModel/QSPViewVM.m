//
//  CommonVM.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/19.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "QSPViewVM.h"

@implementation QSPViewVM
@synthesize dataM = _dataM;

- (void)setDataMSet:(id)dataM {
    _dataM = dataM;
}
- (QSPViewVM * (^)(id))dataMSet {
    return ^(id dataM){
        self.dataMSet = dataM;
        
        return self;
    };
}
- (QSPViewVM * (^)(Class, QSPSetDataMBlock))dataMCreate {
    return ^(Class class, QSPSetDataMBlock block){
        id obj = [[class alloc] init];
        if (block) {
            block(obj);
        }
        self.dataMSet(obj);
        
        return self;
    };
}

@end
