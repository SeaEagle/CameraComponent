//
//  ESCameraButton.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "ESViewControllerUtil.h"
#import "ESCameraChoseView.h"
#import "ESCameraChoseTabView.h"
#import "ESCameraPickMultiPicViewController.h"
#import "ESCameraMultiPicScanViewController.h"

@interface ESCameraButton : UIButton
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ESPickMultiPicDelegate>

{
    //业务数据
    int pickPictureType;//获取图片的方式（可配置项）
    BOOL picMaxLimitMark;//图片数量限制标记, YES:限制图片数量, NO:不限制图片数量
    int picMaxCount;//图片数量最大值
    int currentSelectedCount;//已选择的数量
    
    UIViewController *locateViewController;//CameraButton所在的viewController
    
    //获取相片数据的页面
    ESCameraChoseView *cameraChoseView;//灰色遮罩
    ESCameraChoseTabView *cameraChoseTabView;//"本地照片"和"拍照"选择Tab
    UINavigationController *cameraPicMultiPicViewNavigationController;//"本地相册"及"多图预览"的导航管理器
    ESCameraPickMultiPicViewController *cameraPicMultiPicViewController;//"本地相册"
    ESCameraMultiPicScanViewController *cameraMultiPicScanViewController;//"多图预览"
    
}

@property UIViewController *locateViewController;

@end
