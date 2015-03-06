//
//  ESSnapshootRecordTableViewController.m
//  CameraComponent
//
//  Created by SeaEagle on 15/3/5.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootRecordTableViewController.h"

@implementation ESSnapshootRecordTableViewController

#pragma mark - 初始化
- (void)viewDidLoad{
    
    // 
    UINib *nib = [UINib nibWithNibName:@"ESSnapshootRecordItem" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SNAPSHOOTRECORDCELLIDENTIFIER];
    
    // 清除多余的分割线
    [self clearExtraSperateLine];
}

// 清空多余的分割线
- (void)clearExtraSperateLine{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - Table view data source
// 表的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// 表的每一列
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSnapshootRecordItem *cell = [tableView dequeueReusableCellWithIdentifier:SNAPSHOOTRECORDCELLIDENTIFIER forIndexPath:indexPath];
    [cell updateDisplayContent:nil];
    return cell;
}

// 设置每一列的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

@end
