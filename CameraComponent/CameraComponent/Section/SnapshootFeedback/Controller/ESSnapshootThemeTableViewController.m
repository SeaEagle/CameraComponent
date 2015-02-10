//
//  ESSnapshootThemeTableViewController.m
//  CameraComponent
//
//  Created by SeaEagle on 15/2/10.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootThemeTableViewController.h"

@interface ESSnapshootThemeTableViewController ()

@end

@implementation ESSnapshootThemeTableViewController

#pragma mark - 初始化
// 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化拍照主题数据
    [self initSnapshootThemeData];
    
    // 清除选项
    // self.clearsSelectionOnViewWillAppear = NO;
    // 编辑
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化拍照主题数据
- (void)initSnapshootThemeData{
    // 通过接口获取拍照主题数据
    // 解析接口返回数据
    // 初始化主题数据
    snapshootThemeData = [[NSMutableArray alloc]init];
    
    ESSnapshootTheme *theme1 = [[ESSnapshootTheme alloc]init];
    theme1.themeId = @"1";
    theme1.themeName = @"theme1";
    [snapshootThemeData addObject:theme1];
    theme1.subThemes = [[NSMutableArray alloc]init];
    ESSnapshootTheme *subtheme11 = [[ESSnapshootTheme alloc]init];
    subtheme11.themeId = @"11";
    subtheme11.themeName = @"subtheme11";
    [theme1.subThemes addObject:subtheme11];
    ESSnapshootTheme *subtheme12 = [[ESSnapshootTheme alloc]init];
    subtheme12.themeId = @"12";
    subtheme12.themeName = @"subtheme12";
    [theme1.subThemes addObject:subtheme12];
    
    ESSnapshootTheme *theme2 = [[ESSnapshootTheme alloc]init];
    theme2.themeId = @"2";
    theme2.themeName = @"theme2";
    [snapshootThemeData addObject:theme2];
    
    ESSnapshootTheme *theme3 = [[ESSnapshootTheme alloc]init];
    theme3.themeId = @"3";
    theme3.themeName = @"theme3";
    [snapshootThemeData addObject:theme3];
    theme3.subThemes = [[NSMutableArray alloc]init];
    ESSnapshootTheme *subtheme31 = [[ESSnapshootTheme alloc]init];
    subtheme31.themeId = @"31";
    subtheme31.themeName = @"subtheme31";
    [theme3.subThemes addObject:subtheme31];
    ESSnapshootTheme *subtheme32 = [[ESSnapshootTheme alloc]init];
    subtheme32.themeId = @"32";
    subtheme32.themeName = @"subtheme32";
    [theme3.subThemes addObject:subtheme32];
}

#pragma mark - 导航跳转前处理
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - Table view data source
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [snapshootThemeData count];
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THEMECELLIDENTIFIER forIndexPath:indexPath];
    
    ESSnapshootTheme *theme = [snapshootThemeData objectAtIndex:indexPath.row];
    cell.textLabel.text = theme.themeName;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end