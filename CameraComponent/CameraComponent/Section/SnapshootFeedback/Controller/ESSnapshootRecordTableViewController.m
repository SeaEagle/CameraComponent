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
         [self.tableView reloadData];
     }onError:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
         //
         NSLog(@"Error: %@", error.description);
     }];
}

// 处理获取到的记录数据
- (void)manageSnapshootRecord:(NSArray *)dataArray{
    for (NSDictionary *data in dataArray) {
        // 注: data的key要跟接口返回对应上
        ESSnapshootRecord *record = [[ESSnapshootRecord alloc]init];
        record.address = [data objectForKey:@"address"];
        record.mobile = [data objectForKey:@"mobile"];
        record.remark = [data objectForKey:@"remark"];
        record.title = [data objectForKey:@"title"];
        record.uploadName = [data objectForKey:@"uploadName"];
        record.uploadTime = [data objectForKey:@"uploadTime"];
        record.photos = [data objectForKey:@"photos"];
        [snapshootRecord addObject:record];//
    }
}

#pragma mark - Table view data source
// 表的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (nil==snapshootRecord) {
        //
        snapshootRecord = [[NSMutableArray alloc]init];
    }
    return [snapshootRecord count];
}

// 表的每一列
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESSnapshootRecordItem *cell = [tableView dequeueReusableCellWithIdentifier:SNAPSHOOTRECORDCELLIDENTIFIER forIndexPath:indexPath];
    [cell updateDisplayContent:[snapshootRecord objectAtIndex:indexPath.row]];
    return cell;
}

// 设置每一列的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

// 选择某列之后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
