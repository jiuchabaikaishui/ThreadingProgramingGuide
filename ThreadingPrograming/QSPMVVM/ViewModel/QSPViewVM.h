//
//  CommonVM.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/19.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSPViewVM : NSObject

typedef void (^QSPSetDataMBlock)(id);

@property (strong, nonatomic, readonly) id dataM;

- (QSPViewVM * (^)(id))dataMSet;
- (QSPViewVM * (^)(Class, QSPSetDataMBlock))dataMCreate;

@end
