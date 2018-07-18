//
//  CommonTableViewHelper.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/18.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "CommonTableViewHelper.h"

@implementation CommonTableViewHelper

- (void)setTableViewModel:(CommonTableViewModel *)model {
    _tableViewModelV = model;
}

- (CommonTableViewHelper * (^)(CommonTableViewModelBlock))tableViewModel {
    return ^(CommonTableViewModelBlock block) {
        CommonTableViewModel *model = [[CommonTableViewModel alloc] init];
        if (block) {
            block(model);
        }
        self.tableViewModel = model;
        
        return self;
    };
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewModelV.sectionCountV;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewModelV sectionModelWithSection:section].rowCountV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MainTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    CommonTableViewRowModel *rowModel = [self.tableViewModelV rowModelWithIndexPath:indexPath];
    cell.textLabel.text = rowModel.titleV;
    cell.detailTextLabel.text = rowModel.detailsV;
    cell.accessoryType = rowModel.selectedBlockV ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonTableViewRowModel *rowModel = [self.tableViewModelV rowModelWithIndexPath:indexPath];
    if (rowModel.selectedBlockV) {
        rowModel.selectedBlockV(tableView, indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 188;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"MainTableViewHeaderFooterView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    
    CommonTableViewSectionModel *sectionModel = [self.tableViewModelV sectionModelWithSection:section];
    header.textLabel.text = sectionModel.titleV;
    header.detailTextLabel.text = sectionModel.detailsV;
    header.contentView.backgroundColor = [UIColor redColor];
    
    return header;
}

@end
