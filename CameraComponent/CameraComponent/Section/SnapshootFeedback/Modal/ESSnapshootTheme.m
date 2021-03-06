//
//  SnapshootTheme.m
//  CameraComponent
//
//  Created by SeaEagle on 15/2/10.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootTheme.h"

@implementation ESSnapshootTheme

// 主题ID
@synthesize themeId;
// 主题名称
@synthesize themeName;
// 主题名称 - 显示
@synthesize displayThemeName;
// 子主题
@synthesize subThemes;

// 初始化主题数据
+ (NSArray *)initSnapshootThemeData:(NSArray *)dataArray{
    NSMutableArray *snapshootThemeData = [[NSMutableArray alloc]init];
    [ESSnapshootTheme recurrenceSnapshootThemeData:snapshootThemeData withDataArray:dataArray preTitle:@""];
    return snapshootThemeData;
}

// 递归处理主题
+ (void)recurrenceSnapshootThemeData:(NSMutableArray *)snapshootThemeData withDataArray:(NSArray *)dataArray preTitle:(NSString *)preTitle{
    for (NSDictionary *snapshootTheme in dataArray) {
        ESSnapshootTheme *theme = [[ESSnapshootTheme alloc]init];
        theme.themeId = [snapshootTheme objectForKey:@"id"];
        theme.themeName = [snapshootTheme objectForKey:@"tittle"];
        if ( [preTitle isEqualToString:@""] ) {
            theme.displayThemeName = [snapshootTheme objectForKey:@"tittle"];
        }else{
            theme.displayThemeName = [NSString stringWithFormat:@"%@ / %@", preTitle, theme.themeName];
        }
        NSArray *childrenTheme = [snapshootTheme objectForKey:@"children"];
        [snapshootThemeData addObject:theme];
        if ( 0 != [childrenTheme count] ) {
            theme.subThemes = [[NSMutableArray alloc]init];
            [ESSnapshootTheme recurrenceSnapshootThemeData:theme.subThemes withDataArray:childrenTheme preTitle:theme.themeName];
        }
    }

}

@end
