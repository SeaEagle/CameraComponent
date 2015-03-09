//
//  ESSnapshootRecord.h
//  CameraComponent
//
//  Created by SeaEagle on 15/3/9.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSnapshootRecord : NSObject
{
    NSString *title;// 拍照主题
    NSString *address;// 中文地址
    NSString *remark;// 备注
    NSString *mobile;// 上传者手机号码
    NSString *uploadName;// 上传者姓名
    NSString *uploadTime;// 上传时间
    // 照片信息 - 每一项以字典的形式存放
    // 字典的key: picLocation:小图地址 bigPicLocation:大图地址 picType:照片类型
    NSMutableArray *photos;
}

#pragma mark - 属性说明
@property NSString *title;
@property NSString *address;
@property NSString *remark;
@property NSString *mobile;
@property NSString *uploadName;
@property NSString *uploadTime;
@property NSMutableArray *photos;

#pragma mark - 方法说明

@end
