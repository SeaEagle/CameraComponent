//
//  ESCameraChoseTabView.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/26.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESColorUtil.h"

//
@interface ESCameraChoseTabView : UIView
{
    CGFloat standOutlineHeight;//
    CGFloat realOutlineHeight;//
    CGFloat standOutlineWidth;//
    CGFloat realOutlineWidth;//
    CGFloat standTitleHeight;//
    CGFloat realTitleHeight;//
    CGFloat spliteLineWidth;//
    CGPoint horizonSpliteLineBegin;//水平分割线起点
    CGPoint horizonSpliteLineEnd;//水平分割线终点
    CGPoint verticalSpliteLineBegin;//垂直分割线起点
    CGPoint verticalSpliteLineEnd;//垂直分割线终点
    NSString *spliteLineColorHexValue;//
    
    UIImageView *backImageView;//
    UIButton *photoLibraryBtn;//
    UIButton *snapshootBtn;//
}

#pragma mark - 属性声明
@property CGFloat standOutlineHeight;//
@property CGFloat realOutlineHeight;//
@property CGFloat standOutlineWidth;//
@property CGFloat realOutlineWidth;//
@property CGFloat standTitleHeight;//
@property CGFloat realTitleHeight;//
@property CGFloat spliteLineWidth;//
@property CGPoint horizonSpliteLineBegin;//水平分割线起点
@property CGPoint horizonSpliteLineEnd;//水平分割线终点
@property CGPoint verticalSpliteLineBegin;//垂直分割线起点
@property CGPoint verticalSpliteLineEnd;//垂直分割线终点
@property NSString *spliteLineColorHexValue;//

@property UIImageView *backImageView;//
@property UIButton *photoLibraryBtn;//
@property UIButton *snapshootBtn;//

@end
