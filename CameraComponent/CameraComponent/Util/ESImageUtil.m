//
//  ESImageUtil.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/27.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESImageUtil.h"

@implementation ESImageUtil

//
+ (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGFloat originalAspect = original.size.width / original.size.height;
    CGFloat targetAspect = size.width / size.height;
    CGRect targetRect;
    if (originalAspect>targetAspect) {
        targetRect.size.width = size.width;
        targetRect.size.height = size.height*targetAspect/originalAspect;
        targetRect.origin.x = 0;
        targetRect.origin.y = (size.height - targetRect.size.height)*0.5;
    }else if(originalAspect<targetAspect){
        targetRect.size.width = size.width*originalAspect/targetAspect;
        targetRect.size.height = size.height;
        targetRect.origin.x = (size.width - targetRect.size.width)*0.5;
        targetRect.origin.y = 0;
    }else{
        targetRect = CGRectMake(0, 0, size.width, size.height);
    }
    [original drawInRect:targetRect];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}

@end
