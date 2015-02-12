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
#import "ESCameraComponent.h"

@interface ESSnapshootFeedbackViewController : UIViewController
<ESSnapshootFeedbacThemekDelegate>
{
    ESCameraComponent *cameraComponent;
}

//容器视图
@property (weak, nonatomic) IBOutlet UIView *containerView;

//拍照控件的容器视图
@property (weak, nonatomic) IBOutlet UIView *snapshootView;

//


@end
