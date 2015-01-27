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

@interface ESCameraButton : UIButton
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    int pickPictureType;//获取图片的方式（可配置项）
    int finalPictureType;//
    
    UIViewController *locateViewController;//CameraButton所在的viewController
    ESCameraChoseView *cameraChoseView;//
    ESCameraChoseTabView *cameraChoseTabView;//
}

@end
