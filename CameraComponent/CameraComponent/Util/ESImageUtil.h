//
//  ESImageUtil.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/27.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ESImageUtil : NSObject

+ (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size;

@end
