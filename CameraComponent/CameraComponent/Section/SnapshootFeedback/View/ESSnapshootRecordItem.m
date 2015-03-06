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
- (void)updateDisplayContent:(NSDictionary *)contentDictionary{
    _snapshootThemeTitle.text = @"拍照主题";
    _snapshootTime.text = @"2015-03-06 08:30";
    _snapshootDescription.text = @"这只是一个备注";
    _snapshootLocation.text = @"红星美卡龙";
}

@end
