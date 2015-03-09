//
//  ESSnapshootRecordTableViewController.h
//  CameraComponent
//
//  Created by SeaEagle on 15/3/5.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESNetworkClient.h"
#import "ESSnapshootRecordItem.h"

// 拍照主题Cell
static NSString *SNAPSHOOTRECORDCELLIDENTIFIER = @"SnapshootRecordItem";
//
static CGFloat CELLHEIGHT = 274;

@interface ESSnapshootRecordTableViewController : UITableViewController
{
    ESNetworkClient *networkClient;
    NSMutableArray *snapshootRecord;
    
}

@property NSMutableArray *snapshootRecord;

@end