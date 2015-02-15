//
//  ESSnapshootFeedback.h
//  CameraComponent
//
//  Created by SeaEagle on 15/2/15.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ESSnapshootTheme.h"

@interface ESSnapshootFeedback : NSObject

@property ESSnapshootTheme *theme;// 拍照主题
@property NSArray *imageData;// 图片数据
@property NSString *remark;// 备注

- (NSDictionary *)getParameterDictionary;

@end