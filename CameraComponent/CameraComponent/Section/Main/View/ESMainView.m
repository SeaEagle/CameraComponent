//
//  ESMainView.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/21.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESMainView.h"

@implementation ESMainView

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if (self) {
        CGRect frame = [[UIScreen mainScreen]applicationFrame];
        frame.origin.y = 0;
        //声明拍照组件
        ESCameraComponent *cameraComponent = [[ESCameraComponent alloc]initWithFrame:frame];
        //指定获取相片的方式, 是否限制拍照数量, 拍照数量最大值
        [cameraComponent configureComponentWithType:ESPhotoLibraryOrCamera maxLimitMark:YES maxCount:5];
        //添加到view
        [self addSubview:cameraComponent];
    }
    return(self);
}

@end
