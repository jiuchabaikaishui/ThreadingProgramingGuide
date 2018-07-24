//
//  QSPTableViewVM.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/19.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "QSPViewVM.h"
#import "QSPTableViewSectionVM.h"
#import "QSPTableViewCell.h"
#import "QSPTableViewHeaderView.h"
#import "QSPTableViewFooterView.h"

@class QSPTableViewVM;

typedef void (^QSPCreateObjectBlock)(id);

@interface QSPTableViewVM : QSPViewVM <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic, readonly) NSInteger section;
@property (strong, nonatomic, readonly) UIView *tableHeaderView;
@property (strong, nonatomic, readonly) UIView *tableFooterView;

- (QSPTableViewVM * (^)(QSPTableViewSectionVM *))addSectionVM;
- (QSPTableViewVM * (^)(Class, QSPCreateObjectBlock))addSectionVMCreate;
- (QSPTableViewVM * (^)(UIView *))tableHeaderViewSet;
- (QSPTableViewVM * (^)(UIView *))tableFooterViewSet;
- (QSPTableViewVM * (^)(Class, QSPCreateObjectBlock))tableHeaderViewCreate;
- (QSPTableViewVM * (^)(Class, QSPCreateObjectBlock))tableFooterViewCreate;

- (QSPTableViewSectionVM *)sectionMVWithSection:(NSInteger)section;
- (QSPTableViewCellVM *)rowMVWithIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)sectionOfSctionVM:(QSPTableViewSectionVM *)vm;

@end
