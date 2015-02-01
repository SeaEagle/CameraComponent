//
//  ESCameraComponent.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

//#import "ESCameraButton.h"
#import "ESViewControllerUtil.h"
#import "ESCameraDefine.h"
#import "ESCameraDelegate.h"
#import "ESCameraChoseView.h"
#import "ESCameraChoseTabView.h"
#import "ESCameraPickMultiPicViewController.h"
#import "ESCameraMultiPicScanViewController.h"

@interface ESCameraComponent : UIScrollView
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ESPickMultiPicDelegate>
{
    // 业务数据相关
    UIViewController *currentViewController;//当前viewController
    ESPickPictureType pickPictureType;//获取图片的方式(1:直接拍照或从相册获取, 2:直接拍照, 3:从相册获取)
    BOOL originalMark;//原图标记, YES:使用原图, NO:不使用原图
    BOOL picMaxLimitMark;//图片数量限制标记, YES:限制图片数量, NO:不限制图片数量
    int picMaxCount;//图片数量最大值
    int currentSelectedCount;//已选择的数量
    int currentPhotoLibrarySelectedCount;//本地照片中已选择的数量
    
    //图片数据
    NSMutableDictionary *imageDataFromPhotoLibrary;//保存从本地照片挑选的照片
    NSMutableArray *imageData;//用于展示
    
    //
    BOOL initMark;//是否已进行必要的初始化
    
    //
    CGFloat standComponentOutlineWidth;//拍照组件外框的标准宽度
    CGFloat standComponentOutlineHeight;//拍照组件外框的标准高度
    CGSize componentOutlineSize;//拍照组件外框的实际大小
    CGPoint componentPoint;//拍照组件的位置
    CGFloat standComponentHorizonSpan;//控件左右与边缘的标准间距
    CGFloat componentHorizonSpan;//控件左右与边缘的间距
    CGFloat standComponentVerticalSpan;//控件上下与边缘的标准间距
    CGFloat componentVerticalSpan;//控件上下与边缘的间距
    CGFloat standTitleHeight;//原图所在一列为title
    CGFloat titleHeight;//
    
    //原图选项按钮
    UIImage *originalOption;//原图-背景图
    UIImage *noOriginalOption;//不使用原图-背景图
    UIImageView *originalButtonImageVIew;//
    UIButton *originalButton;//
    
    //获取图片的按钮
    CGSize standCameraButtonSize;//标准的获取图片按钮的大小
    CGSize cameraButtonSize;//
    CGPoint cameraButtonPoint;//
    UIButton *cameraButton;//
    
    //获取相片数据的页面
    ESCameraChoseView *cameraChoseView;//灰色遮罩
    ESCameraChoseTabView *cameraChoseTabView;//"本地照片"和"拍照"选择Tab
    UINavigationController *cameraPicMultiPicViewNavigationController;//"本地相册"及"多图预览"的导航管理器
    ESCameraPickMultiPicViewController *cameraPicMultiPicViewController;//"本地相册"
    ESCameraMultiPicScanViewController *cameraMultiPicScanViewController;//"多图预览"
}

#pragma mark - 属性声明

#pragma mark - 方法声明
//对组件的配置
- (void)configureComponentWithType:(ESPickPictureType)type maxLimitMark:(BOOL)mark maxCount:(int)count;

//获取该控件中所获取的图片
- (NSArray *)getImageData;

@end
