//
//  ESCameraComponent.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraComponent.h"

@implementation ESCameraComponent


#pragma mark -
// 初始化
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self customizedPresetValue];
        //
        [self customizedGlobalView];
        //
        [self customizedOriginalOption];
        //
        [self customizedCameraButton];
    }
    return self;
}

#pragma mark - 样式
// 预设值
- (void)customizedPresetValue{
    
    //
    CGRect frame = self.frame;
    componentOutlineSize = frame.size;
    
    //标准值
    standComponentOutlineWidth = 750;//
    standComponentOutlineHeight = 306;//
    standComponentHorizonSpan = 24;//
    standComponentVerticalSpan = 41;//
    standCameraButtonSize = CGSizeMake(192, 232);//
    
    //大小计算
    componentOutlineSize.height = componentOutlineSize.width*standComponentOutlineHeight/standComponentOutlineWidth;
    frame.size = componentOutlineSize;
    self.frame = frame;
    
    componentHorizonSpan = componentOutlineSize.width*standComponentHorizonSpan/standComponentOutlineWidth;//
    componentVerticalSpan = componentOutlineSize.width*standComponentVerticalSpan/standComponentOutlineWidth;//
    cameraButtonSize = CGSizeMake(componentOutlineSize.width*standCameraButtonSize.width/standComponentOutlineWidth, componentOutlineSize.width*standCameraButtonSize.height/standComponentOutlineWidth);
    
    //位置计算
    cameraButtonPoint = CGPointMake(0, 0);
}

// 全局view
- (void)customizedGlobalView{
    self.backgroundColor = [UIColor purpleColor];
}

// 原图选项的按钮
- (void)customizedOriginalOption{}

// 获取图片的按钮
- (void)customizedCameraButton{
    cameraButton = [[ESCameraButton alloc]initWithFrame:CGRectMake(cameraButtonPoint.x, cameraButtonPoint.y, cameraButtonSize.width, cameraButtonSize.height)];
    cameraButton.backgroundColor = [UIColor yellowColor];
    [self addSubview:cameraButton];
}

@end