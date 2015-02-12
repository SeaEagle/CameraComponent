//
//  SnapshootTheme.h
//  CameraComponent
//
//  Created by SeaEagle on 15/2/10.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSnapshootTheme : NSObject

// 主题ID
@property NSString *themeId;
// 主题名称
@property NSString *themeName;
// 主题名称 - 显示
@property NSString *displayThemeName;
// 子主题
@property NSMutableArray *subThemes;


+ (NSArray *)initSnapshootThemeData:(NSArray *)dataArray;

@end
