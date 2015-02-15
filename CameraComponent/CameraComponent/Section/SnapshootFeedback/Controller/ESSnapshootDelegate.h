//
//  SnapshootDelegate.h
//  CameraComponent
//
//  Created by SeaEagle on 15/2/10.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootTheme.h"

#ifndef CameraComponent_SnapshootDelegate_h
#define CameraComponent_SnapshootDelegate_h

// 拍照反馈
@protocol ESSnapshootFeedbackDelegate <NSObject>

@end

// 拍照反馈-主题代理
@protocol ESSnapshootFeedbacThemekDelegate <NSObject>

@required
- (void)handleThemeOperation:(ESSnapshootTheme *)theme;

@end

// 拍照主题-子主题代理
@protocol ESSnapshootFeedbacSubThemeDelegate <NSObject>

@required
- (void)handleSubThemeOperation:(ESSnapshootTheme *)subTheme;

@end

#endif