//
//  SectionModel.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonRowModel.h"
#import "CommonModelDefine.h"

@interface CommonSectionModel : NSObject

typedef void (^SectionModelCreateBlock)(CommonRowModel *);

- (CommonSectionModel * (^)(NSString *))title;
- (CommonSectionModel * (^)(NSString *))details;
- (CommonSectionModel * (^)(NSInteger))section;
- (CommonSectionModel * (^)(SectionModelCreateBlock))addRowModel;

@end
