//
//  QSPTableViewVM.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/19.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "QSPTableViewVM.h"

@interface QSPTableViewVM ()

@property (strong, nonatomic) NSMutableArray<QSPTableViewSectionVM *> *sectionVMs;

@end

@implementation QSPTableViewVM

- (instancetype)init {
    if (self = [super init]) {
        self.tableFooterViewCreate(UIView.class, nil);
    }
    
    return self;
}

- (NSMutableArray *)sectionVMs {
    if (_sectionVMs == nil) {
        _sectionVMs = [NSMutableArray arrayWithCapacity:1];
    }
    
    return _sectionVMs;
}
- (NSInteger)section {
    return self.sectionVMs.count;
}

- (QSPTableViewVM * (^)(QSPTableViewSectionVM *))addSectionVM {
    return ^(QSPTableViewSectionVM *sectionVM){
        [self.sectionVMs addObject:sectionVM];
        
        return self;
    };
}
- (QSPTableViewVM * (^)(Class, QSPCreateObjectBlock))addSectionVMCreate {
    return ^(Class class, QSPCreateObjectBlock block){
        QSPTableViewSectionVM *sectionVM = [[class alloc] init];
        if (block) {
            block(sectionVM);
        }
        [self.sectionVMs addObject:sectionVM];
        
        return self;
    };
}
- (void)setTableHeaderViewSet:(UIView *)tableHeaderView {
    _tableHeaderView = tableHeaderView;
}
- (QSPTableViewVM * (^)(UIView *))tableHeaderViewSet {
    return ^(UIView *view){
        self.tableHeaderViewSet = view;
        
        return self;
    };
}
- (QSPTableViewVM * (^)(Class, QSPCreateObjectBlock))tableHeaderViewCreate {
    return ^(Class class, QSPCreateObjectBlock block){
        UIView *view = [[class alloc] init];
        if (block) {
            block(view);
        }
        self.tableHeaderViewSet = view;
        
        return self;
    };
}
- (void)setTableFooterViewSet:(UIView *)tableFooterView {
    _tableFooterView = tableFooterView;
}
- (QSPTableViewVM * (^)(UIView *))tableFooterViewSet {
    return ^(UIView *view){
        self.tableFooterViewSet = view;
        
        return self;
    };
}
- (QSPTableViewVM * (^)(Class, QSPCreateObjectBlock))tableFooterViewCreate {
    return ^(Class class, QSPCreateObjectBlock block){
        UIView *view = [[class alloc] init];
        if (block) {
            block(view);
        }
        self.tableFooterViewSet = view;
        
        return self;
    };
}

- (QSPTableViewSectionVM *)sectionMVWithSection:(NSInteger)section {
    return [self.sectionVMs objectAtIndex:section];
}
- (QSPTableViewCellVM *)rowMVWithIndexPath:(NSIndexPath *)indexPath {
    return [[self.sectionVMs objectAtIndex:indexPath.section] rowModelWithRow:indexPath.row];
}
- (NSInteger)sectionOfSctionVM:(QSPTableViewSectionVM *)vm {
    return [self.sectionVMs indexOfObject:vm];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionVMs.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self sectionMVWithSection:section].rowCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QSPTableViewCellVM *rowMV = [self rowMVWithIndexPath:indexPath];
    
    return rowMV.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QSPTableViewCellVM *rowMV = [self rowMVWithIndexPath:indexPath];
    Class cellClass = rowMV.cellClass ? rowMV.cellClass : QSPTableViewCell.class;
    NSString *identifier = NSStringFromClass(cellClass);
    QSPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:rowMV.style reuseIdentifier:identifier];
    }
    
    cell.cellVMSet(rowMV);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QSPTableViewCellVM *rowMV = [self rowMVWithIndexPath:indexPath];
    if (rowMV.selectedBlock) {
        rowMV.selectedBlock(tableView, indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    QSPTableViewSectionVM *sectionVM = [self sectionMVWithSection:section];

    return sectionVM.headerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QSPTableViewSectionVM *sectionVM = [self sectionMVWithSection:section];
    Class headerClass = sectionVM.headerClass ? sectionVM.headerClass : QSPTableViewHeaderView.class;
    if (headerClass) {
        NSString *identifier = NSStringFromClass(headerClass);
        QSPTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (header == nil) {
            header = [[headerClass alloc] initWithReuseIdentifier:identifier];
        }
        
        header.sectionVMSet(sectionVM);
        
        return header;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    QSPTableViewSectionVM *sectionVM = [self sectionMVWithSection:section];

    return sectionVM.footerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    QSPTableViewSectionVM *sectionVM = [self sectionMVWithSection:section];
    if (sectionVM.footerClass) {
        NSString *identifier = NSStringFromClass(sectionVM.footerClass);
        QSPTableViewFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (footer == nil) {
            footer = [[sectionVM.footerClass alloc] initWithReuseIdentifier:identifier];
        }

        footer.sectionVMSet(sectionVM);

        return footer;
    }

    return nil;
}

@end
