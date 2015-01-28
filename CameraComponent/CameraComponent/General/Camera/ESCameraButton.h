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
#import "ESCameraMultiPicScanView.h"

@interface ESCameraButton : UIButton
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PickMultiPicDelegate>

{
    int pickPictureType;//获取图片的方式（可配置项）
    int finalPictureType;//
    
    UIViewController *locateViewController;//CameraButton所在的viewController
    
    ESCameraChoseView *cameraChoseView;//灰色遮罩
    ESCameraChoseTabView *cameraChoseTabView;//"本地照片"和"拍照"选择Tab
    ESCameraMultiPicScanView *cameraMultiPicScanView;//"多图预览"
    UINavigationController *cameraPicMultiPicViewNavigationController;//
    ESCameraPickMultiPicViewController *cameraPicMultiPicViewController;//
    
}

@property UIViewController *locateViewController;

@end
