//
//  ESSnapshootSubThemeTableView.m
//  CameraComponent
//
//  Created by ElogisticsBase on 15/2/12.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootSubThemeTableView.h"

@implementation ESSnapshootSubThemeTableView

@synthesize themeData;

#pragma mark - 初始化
//
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.dataSource = self;
        //
        self.delegate = self;
        //
        [self clearExtraSperateLine];
    }
    return self;
}

// 清空多余的分割线
- (void)clearExtraSperateLine{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

#pragma mark - 
// 表的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [themeData count];
}

// 表的每一列
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBTHEMECELLIDENTIFIER];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SUBTHEMECELLIDENTIFIER];
    }
    ESSnapshootTheme *theme = [themeData objectAtIndex:indexPath.row];
    cell.textLabel.text = theme.themeName;
    return cell;
}

// 设置每一列的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

@end
