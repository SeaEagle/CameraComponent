//
//  ESUrlImageCache.h
//  CameraComponent
//
//  Created by ElogisticsBase on 15/3/11.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSMutableDictionary *urlImageCache;

@interface ESUrlImageCache : NSObject

//
+ (UIImage *)getImageWithUrl:(NSString *)imageUrl;

@end
