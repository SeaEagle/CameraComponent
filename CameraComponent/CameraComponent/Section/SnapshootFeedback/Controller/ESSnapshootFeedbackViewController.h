//
//  SnapshootFeedbackViewController.h
//  CameraComponent
//
//  Created by SeaEagle on 15/2/9.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESNetworkClient.h"
#import "ESSnapshootDelegate.h"
#import "ESSnapshootFeedback.h"
#import "ESSnapshootThemeTableViewController.h"
#import "ESCameraComponent.h"

@interface ESSnapshootFeedbackViewController : UIViewController
<ESSnapshootFeedbacThemekDelegate>
{
    // 拍照控件
    ESCameraComponent *cameraComponent;
    //
    ESSnapshootFeedback *snapshootFeedback;
    //
    ESNetworkClient *networkClient;
    // 拍照主题视图
    ESSnapshootThemeTableViewController *snapshootThemeViewController;
}

// 容器视图
@property (weak, nonatomic) IBOutlet UIView *containerView;

// 拍照控件的容器视图
@property (weak, nonatomic) IBOutlet UIView *snapshootView;

// 拍照主题文本框
@property (weak, nonatomic) IBOutlet UITextField *snapshootThemeField;

// 拍照反馈描述
@property (weak, nonatomic) IBOutlet UITextField *snapshootRemarkField;

@end
