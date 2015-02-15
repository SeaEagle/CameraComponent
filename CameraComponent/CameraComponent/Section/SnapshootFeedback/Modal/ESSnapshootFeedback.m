//
//  ESSnapshootFeedback.m
//  CameraComponent
//
//  Created by SeaEagle on 15/2/15.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootFeedback.h"

@implementation ESSnapshootFeedback

@synthesize theme;// 拍照主题
@synthesize imageData;// 图片数据
@synthesize remark;// 备注

- (NSDictionary *)getParameterDictionary{
    NSMutableDictionary *parameterDictionary = [[NSMutableDictionary alloc]init];
    // 设置经度 - 根据控件获取
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",@"112"] forKey:@"longitude"];
    // 设置纬度 - 根据控件获取
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",@"23"] forKey:@"latitude"];
    // 设置海拔 - 根据控件获取
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",@"112"] forKey:@"altitude"];
    // 设置中文地址 - 根据控件获取
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",@"中国"] forKey:@"address"];
    // 设置拍照主题
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",theme.themeId] forKey:@"photoTitleId"];
    // 设置照片类型 - 可修改为配置项 或 由控件决定
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",@"jpg"] forKey:@"picType"];
    // 设置照片数量
    [parameterDictionary setObject:[NSString stringWithFormat:@"%ld",[imageData count]] forKey:@"photoNum"];
    // 设置备注
    [parameterDictionary setObject:[NSString stringWithFormat:@"%@",remark] forKey:@"remark"];
    return parameterDictionary;
}

@end
