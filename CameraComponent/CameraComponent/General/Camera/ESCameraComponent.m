//
//  ESCameraComponent.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraComponent.h"

@implementation ESCameraComponent

#pragma mark - 属性声明
@synthesize currentViewController;//当前viewController
@synthesize originalMark;//原图标记
@synthesize picMaxLimitMark;//图片数量限制标记
@synthesize picMaxCount;//图片数量最大值
@synthesize imageArray;//存放图片的数组

#pragma mark -
//初始化
+ (ESCameraComponent *)instanceCameraComponent{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ESCameraComponent" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if (self) {
        CGRect gridRect = self.frame;
        gridRect.origin.x = 0;
        gridRect.origin.y = 0;
        self.frame = gridRect;
    }
    return(self);
}

#pragma mark - 界面相关
//界面重绘
- (void)reloadCameraComponentView{}

@end
