//
//  ESCameraChoseView.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/26.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraChoseView.h"

//遮罩
@implementation ESCameraChoseView

#pragma mark - 属性声明
@synthesize cameraChoseTabView;//选择tabView

#pragma mark - 初始化
//初始化
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化样式
        [self customizedOutlineStyle];
        //添加tabView
        [self addChoseTab];
    }
    return self;
}

//自定义背景view样式
- (void)customizedOutlineStyle{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];//背景色为黑色, 透明度为30%
    self.frame = [[UIScreen mainScreen] applicationFrame];//获取窗口大小
}

#pragma mark - 选择"相册"或"拍照"的Tab
//初始化选择Tab
- (void)initChoseTab{
    CGRect initFrame = CGRectMake(self.frame.origin.x, self.frame.size.height, self.frame.size.width, 0);
    cameraChoseTabView = [[ESCameraChoseTabView alloc]initWithFrame:initFrame];//在view底部添加tabView
}

//添加选择Tab
- (void)addChoseTab{
    [self initChoseTab];//初始化TabView
    [self addSubview:cameraChoseTabView];//
}

//弹出选择Tab
- (void)showChoseTab{
    CGRect tabViewFrame = cameraChoseTabView.frame;//tabView最初在底部
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//动画的方式
    [UIView setAnimationDuration:0.3];//动画时间
    tabViewFrame.origin.y = tabViewFrame.origin.y - tabViewFrame.size.height;//调整tabView在垂直方向的位置
    cameraChoseTabView.frame = tabViewFrame;//
    [UIView commitAnimations];//动画提交
}

//隐藏选择Tab
- (void)hideChoseTab{
    CGRect tabViewFrame = cameraChoseTabView.frame;//tabView显示在页面底部
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//动画的方式
    [UIView setAnimationDuration:0.3];//动画时间
    tabViewFrame.origin.y = tabViewFrame.origin.y + tabViewFrame.size.height;//调整tabView在垂直方向的位置
    cameraChoseTabView.frame = tabViewFrame;//
    [UIView commitAnimations];//动画提交
}

@end
