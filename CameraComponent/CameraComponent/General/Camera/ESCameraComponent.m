//
//  ESCameraComponent.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraComponent.h"

@implementation ESCameraComponent


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

@end
