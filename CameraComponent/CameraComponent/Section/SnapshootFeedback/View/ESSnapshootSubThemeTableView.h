//
//  ESSnapshootSubThemeTableView.h
//  CameraComponent
//
//  Created by ElogisticsBase on 15/2/12.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESAppMacro.h"

#import "ESSnapshootDelegate.h"
#import "ESSnapshootTheme.h"

// 拍照主题子主题Cell
static NSString *SUBTHEMECELLIDENTIFIER = @"SnapshootSubTheme";
//
static CGFloat CELLHEIGHT = 70;

@interface ESSnapshootSubThemeTableView : UITableView
<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *themeData;
@property id <ESSnapshootFeedbacSubThemeDelegate> subThemeDelegate;

@end
