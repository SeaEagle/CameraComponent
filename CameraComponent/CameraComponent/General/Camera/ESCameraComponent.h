//
//  ESCameraComponent.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESCameraComponent : UIScrollView
{
    UIViewController *currentViewController;//当前viewController
    int pickPicType;//获取图片的方式(1:直接拍照或从相册获取, 2:直接拍照, 3:从相册获取)
    BOOL originalMark;//原图标记, YES:使用原图, NO:不使用原图
    BOOL picMaxLimitMark;//图片数量限制标记, YES:限制图片数量, NO:不限制图片数量
    int picMaxCount;//图片数量最大值
    NSMutableArray *imageArray;//存放图片的数组
}

#pragma mark - 属性声明
@property UIViewController *currentViewController;//当前viewController
@property BOOL originalMark;//原图标记
@property BOOL picMaxLimitMark;//图片数量限制标记
@property int picMaxCount;//图片数量最大值
@property NSMutableArray *imageArray;//存放图片的数组

@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

#pragma mark -
//初始化
+ (ESCameraComponent *)instanceCameraComponent;

#pragma mark - 界面相关
//界面重绘
- (void)reloadCameraComponentView;

@end
