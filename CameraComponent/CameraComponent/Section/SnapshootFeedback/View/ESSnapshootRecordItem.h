//
//  ESSnapshootRecordItem.h
//  CameraComponent
//
//  Created by SeaEagle on 15/3/5.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESSnapshootRecord.h"
#import "ESUrlImageCache.h"

@interface ESSnapshootRecordItem : UITableViewCell
{
    // 缩略图
    NSMutableArray *smallImages;
    // 大图
    NSMutableArray *bigImages;
    // 图片显示大小
    CGFloat standScreenWidth;
    // 图片的宽
    CGFloat standImageWidth;
    CGFloat imageWidth;
    // 图片的高
    CGFloat standImageHeight;
    CGFloat imageHeight;
    // 图片之间的间隔
    CGFloat standImageGap;
    CGFloat imageGap;
}

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
