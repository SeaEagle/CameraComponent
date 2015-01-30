//
//  ESCameraComponent.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESCameraButton.h"

@interface ESCameraComponent : UIScrollView
{
    // 业务数据相关
    UIViewController *currentViewController;//当前viewController
    int pickPicType;//获取图片的方式(1:直接拍照或从相册获取, 2:直接拍照, 3:从相册获取)
    BOOL originalMark;//原图标记, YES:使用原图, NO:不使用原图
    BOOL picMaxLimitMark;//图片数量限制标记, YES:限制图片数量, NO:不限制图片数量
    int picMaxCount;//图片数量最大值
    NSMutableArray *imageArray;//存放图片的数组
    
    //
    CGFloat standComponentOutlineWidth;//
    CGFloat standComponentOutlineHeight;//
    CGSize componentOutlineSize;//
    CGPoint componentPoint;//
    CGFloat standComponentHorizonSpan;//
    CGFloat componentHorizonSpan;//控件左右与边缘的间距
    CGFloat standComponentVerticalSpan;//
    CGFloat componentVerticalSpan;//控件上下与边缘的间距
    CGFloat standTitleHeight;//原图所在一列为title
    CGFloat titleHeight;//
    
    //图片数据
    NSMutableArray *imageData;
    
    //原图选项按钮
    UIImage *originalOption;//原图
    UIImage *noOriginalOption;//不使用原图
    UIImageView *originalButtonImageVIew;//
    UIButton *originalButton;//
    
    //获取图片的按钮
    CGSize standCameraButtonSize;//
    CGSize cameraButtonSize;//
    CGPoint cameraButtonPoint;//
    ESCameraButton *cameraButton;//
}

#pragma mark - 属性声明


@end
