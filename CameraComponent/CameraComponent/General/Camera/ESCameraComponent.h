//
//  ESCameraComponent.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESCameraComponent : UIScrollView

@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

+ (ESCameraComponent *)instanceCameraComponent;

@end
