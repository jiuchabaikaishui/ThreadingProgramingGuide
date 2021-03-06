//
//  CommonSectionVM.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/19.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "QSPViewVM.h"
#import "QSPTableViewCellVM.h"
#import <UIKit/UIKit.h>

typedef void (^QSPSetRowVMBlock)(id);

@interface QSPTableViewSectionVM : QSPViewVM

@property (assign, nonatomic, readonly) Class headerClass;
@property (assign, nonatomic, readonly) Class footerClass;
@property (assign, nonatomic, readonly) CGFloat headerHeight;
@property (assign, nonatomic, readonly) CGFloat footerHeight;
@property (copy, nonatomic, readonly) NSString *headerTitle;
@property (copy, nonatomic, readonly) NSString *footerTitle;
@property (copy, nonatomic, readonly) NSString *headerDetail;
@property (copy, nonatomic, readonly) NSString *footerDetail;

- (NSInteger)rowCount;
- (QSPTableViewSectionVM * (^)(QSPTableViewCellVM *))addRowVMSet;
- (QSPTableViewSectionVM * (^)(Class, QSPSetRowVMBlock))addRowVMCreate;
- (QSPTableViewSectionVM * (^)(Class))headerClassSet;
- (QSPTableViewSectionVM * (^)(Class))footerClassSet;
- (QSPTableViewSectionVM * (^)(CGFloat))headerHeightSet;
- (QSPTableViewSectionVM * (^)(CGFloat))footerHeightSet;
- (QSPTableViewSectionVM * (^)(NSString *))headerTitleSet;
- (QSPTableViewSectionVM * (^)(NSString *))footerTitleSet;
- (QSPTableViewSectionVM * (^)(NSString *))headerDetailSet;
- (QSPTableViewSectionVM * (^)(NSString *))footerDetailSet;

- (QSPTableViewCellVM *)rowModelWithRow:(NSInteger)row;
- (NSInteger)rowOfCellVM:(QSPTableViewCellVM *)vm;

@end
