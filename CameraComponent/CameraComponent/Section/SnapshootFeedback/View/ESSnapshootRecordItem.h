//
//  ESSnapshootRecordItem.h
//  CameraComponent
//
//  Created by SeaEagle on 15/3/5.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESSnapshootRecord.h"
@interface ESSnapshootRecordItem : UITableViewCell

#pragma mark - 属性
// 拍照主题
@property (weak, nonatomic) IBOutlet UILabel *snapshootThemeTitle;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *snapshootTime;
// 展示图像
@property (weak, nonatomic) IBOutlet UIScrollView *snapshootImages;
// 描述
@property (weak, nonatomic) IBOutlet UILabel *snapshootDescription;
// 位置
@property (weak, nonatomic) IBOutlet UILabel *snapshootLocation;

#pragma mark -
//
- (void)updateDisplayContent:(ESSnapshootRecord *)snapshootRecord;

@end
