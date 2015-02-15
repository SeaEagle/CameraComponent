//
//  ESSnapshootThemeTableViewController.h
//  CameraComponent
//
//  Created by SeaEagle on 15/2/10.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESNetworkClient.h"

#import "ESSnapshootDelegate.h"
#import "ESSnapshootTheme.h"
#import "ESSnapshootSubThemeTableView.h"

// 拍照主题Cell
static NSString *THEMECELLIDENTIFIER = @"SnapshootTheme";

@interface ESSnapshootThemeTableViewController : UITableViewController
<ESSnapshootFeedbacSubThemeDelegate>
{
    // 
    NSArray *snapshootThemeData;
    // 是否已展示子主题页面
    BOOL showSubThemeMark;
    // 子主题tableview
    ESSnapshootSubThemeTableView *subThemeView;
}

@property NSArray *snapshootThemeData;
@property id <ESSnapshootFeedbacThemekDelegate> themeDelegate;

@end
