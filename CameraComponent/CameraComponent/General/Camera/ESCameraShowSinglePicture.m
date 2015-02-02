//
//  ESCameraShowSinglePicture.m
//  CameraComponent
//
//  Created by SeaEagle on 15/2/2.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraShowSinglePicture.h"

@implementation ESCameraShowSinglePicture

#pragma mark - 属性说明
@synthesize imageView;
@synthesize button;

#pragma mark -
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //
        [self customizedOutlook];
    }
    return self;
}

#pragma mark - 样式自定义
- (void)customizedOutlook{
    imageView = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:imageView];
    button = [[UIButton alloc]initWithFrame:self.frame];
    button.backgroundColor  = [UIColor clearColor];
    [self addSubview:button];
}

@end
