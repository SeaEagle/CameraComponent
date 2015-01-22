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

@interface ESCameraButton : UIButton
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    //获取图片的方式（可配置项）
    int pickPictureType;
    //
    int finalPictureType;
}

@property(strong, nonatomic) UIViewController *locateViewController;//CameraButton所在的viewController

@end
