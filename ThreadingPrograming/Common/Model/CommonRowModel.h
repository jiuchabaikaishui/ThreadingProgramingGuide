//
//  RowModel.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/17.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonModelDefine.h"

@interface CommonRowModel : NSObject

typedef void (^RowModelSelectedBlock)(id, NSIndexPath *);

- (CommonRowModel * (^)(NSString *))title;
- (CommonRowModel * (^)(NSString *))details;
- (CommonRowModel * (^)(NSInteger))row;
- (CommonRowModel * (^)(RowModelSelectedBlock))selectedBolck;

@end
