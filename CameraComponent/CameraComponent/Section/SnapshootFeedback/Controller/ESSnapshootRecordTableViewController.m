//
//  ESSnapshootRecordTableViewController.m
//  CameraComponent
//
//  Created by SeaEagle on 15/3/5.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootRecordTableViewController.h"

@implementation ESSnapshootRecordTableViewController

@synthesize snapshootRecord;// 拍照记录

#pragma mark - 初始化
- (void)viewDidLoad{
    
    // 
    UINib *nib = [UINib nibWithNibName:@"ESSnapshootRecordItem" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SNAPSHOOTRECORDCELLIDENTIFIER];
    
    // 获取拍照记录数据
    [self getSnapshootRecord];
    
    // 清除多余的分割线
    [self clearExtraSperateLine];
}

// 清空多余的分割线
- (void)clearExtraSperateLine{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - 获取拍照记录数据
// 获取拍照记录数据
- (void)getSnapshootRecord{
    // 获取相关的参数
    
    // 通过接口提交数据
    if ( nil == networkClient ) {
        networkClient = [[ESNetworkClient alloc]initManager];
    }
    // 设置参数 - (此处参数需要动态获得)
    NSDictionary *token = [[NSDictionary alloc]initWithObjectsAndKeys:@"1010200", @"x-action-type", @"111", @"x-session-id", nil];
    NSDictionary *paramer = [[NSDictionary alloc]initWithObjectsAndKeys:@"10", @"max", @"0", @"offset", nil];
    
    // 提交数据
    [networkClient
     getJson:token
     params:paramer
     onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
         // 解析接口返回数据
         NSString *resultContent = [JSON objectForKey:@"result"];
         if ( nil != resultContent ) {
             NSData *resultData = [resultContent dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
             [self manageSnapshootRecord:[resultDictionary objectForKey:@"photoFeedbacks"]];
         }else{
             NSLog(@"%@", [JSON objectForKey:@"statusText"]);
             [[[UIAlertView alloc]initWithTitle:@"提示"
                                        message:@"获取不到拍照记录数据"
                                       delegate:nil
                              cancelButtonTitle:@"取消"
                              otherButtonTitles: nil]
              show];
         }
     }onError:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
         //
         NSLog(@"Error: %@", error.description);
     }];
}

// 处理获取到的记录数据
- (void)manageSnapshootRecord:(NSArray *)dataArray{
    NSLog(@"%@",dataArray);
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
