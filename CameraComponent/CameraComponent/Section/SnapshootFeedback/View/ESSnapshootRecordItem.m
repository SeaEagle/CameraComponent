//
//  ESSnapshootRecordItem.m
//  CameraComponent
//
//  Created by SeaEagle on 15/3/5.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootRecordItem.h"

@implementation ESSnapshootRecordItem

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - 根据数据刷新显示的内容
//
- (void)updateDisplayContent:(ESSnapshootRecord *)snapshootRecord{
    _snapshootThemeTitle.text = snapshootRecord.title;//主题
    _snapshootTime.text = snapshootRecord.uploadTime;//上传时间
    _snapshootDescription.text = snapshootRecord.remark;//备注
    _snapshootLocation.text = snapshootRecord.address;//地址
    [self updateImagesDisplay:snapshootRecord.photos];
}

// 更新图片显示
- (void)updateImagesDisplay:(NSArray *)images{
    for (NSDictionary *data in images) {
        // data对应的key有:
        // picType: 图片类型
        // picLocation: 小图
        // bigPicLocation: 大图
        
    }
}

@end
