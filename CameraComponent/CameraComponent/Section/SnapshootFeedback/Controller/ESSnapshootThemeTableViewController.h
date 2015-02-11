//
//  ESSnapshootThemeTableViewController.h
//  CameraComponent
//
//  Created by SeaEagle on 15/2/10.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESNetworkClient.h"
#import "ESSnapshootTheme.h"

//
static NSString *THEMECELLIDENTIFIER = @"SnapshootTheme";

@interface ESSnapshootThemeTableViewController : UITableViewController
{
    NSMutableArray *snapshootThemeData;
}

@end
