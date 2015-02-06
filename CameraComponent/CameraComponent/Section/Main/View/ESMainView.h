//
//  ESMainView.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/21.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

//使用拍照控件必须声明的两个头文件
#import "ESCameraComponent.h"
#import "ESCameraDefine.h"

#import "AFNetworking.h"

@interface ESMainView : UIView
{
    ESCameraComponent *cameraComponent;
}

@end
