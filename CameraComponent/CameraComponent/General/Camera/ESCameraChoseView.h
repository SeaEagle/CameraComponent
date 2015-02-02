//
//  ESCameraChoseView.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/26.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCameraChoseTabView.h"

//遮罩
@interface ESCameraChoseView : UIView
{
    UIButton *globalButton;//全局按钮
    ESCameraChoseTabView *cameraChoseTabView;//选择tabView
}

#pragma mark - 属性声明
@property ESCameraChoseTabView *cameraChoseTabView;//选择tabView
@property UIButton *globalButton;//

#pragma mark - 选择"相册"或"拍照"的Tab
//弹出选择Tab
- (void)showChoseTab;

//隐藏选择Tab
- (void)hideChoseTab;

@end
