//
//  ESCameraShowSinglePicture.h
//  CameraComponent
//
//  Created by SeaEagle on 15/2/2.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESCameraShowSinglePicture : UIView
{
    //展示图片的imageview
    UIImageView *imageView;
    //
    UIButton *button;
}

#pragma mark - 
@property UIImageView *imageView;
@property UIButton *button;

@end
