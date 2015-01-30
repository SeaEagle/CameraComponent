//
//  ESMainView.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/21.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESMainView.h"

@implementation ESMainView

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if (self) {
        CGRect frame = [[UIScreen mainScreen]applicationFrame];
        frame.origin.y = 0;
        ESCameraComponent *cameraComponent = [[ESCameraComponent alloc]initWithFrame:frame];
        [self addSubview:cameraComponent];
    }
    return(self);
}

@end
