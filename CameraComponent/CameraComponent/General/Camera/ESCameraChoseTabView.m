//
//  ESCameraChoseTabView.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/26.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraChoseTabView.h"

//
@implementation ESCameraChoseTabView

#pragma mark - 属性声明
@synthesize standOutlineHeight;//
@synthesize realOutlineHeight;//
@synthesize standOutlineWidth;//
@synthesize realOutlineWidth;//
@synthesize standTitleHeight;//
@synthesize realTitleHeight;//
@synthesize spliteLineWidth;//
@synthesize horizonSpliteLineBegin;//
@synthesize horizonSpliteLineEnd;//
@synthesize verticalSpliteLineBegin;//
@synthesize verticalSpliteLineEnd;//
@synthesize spliteLineColorHexValue;//

@synthesize backImageView;//
@synthesize photoLibraryBtn;//
@synthesize snapshootBtn;//

#pragma mark - 初始化
//初始化
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化标准值
        [self customizedStandValue];
        //初始化样式
        [self customizedOutlineStyle];
        //
        [self calculateSpecifiedValue];
        [self drawSplitLine];//
        [self customizedPhotoLibraryBtn];//
        [self customizedSnapshootBtn];//
    }
    return self;
}

//自定义标准值
- (void)customizedStandValue{
    //标准横宽, 以便做比例转换
    standOutlineHeight = 294.0;//
    standOutlineWidth = 750.0;//
    standTitleHeight = 64.0;//
    spliteLineWidth = 2.0;//
    spliteLineColorHexValue = @"28a8e3";
}

//自定义Tab外框样式
- (void)customizedOutlineStyle{
    self.backgroundColor = [UIColor whiteColor];//背景色
    CGRect tabFrame = self.frame;//
    realOutlineHeight = tabFrame.size.width * standOutlineHeight / standOutlineWidth;//修改tabView的高度
    realOutlineWidth = tabFrame.size.width;
    tabFrame.size.height = realOutlineHeight;
    self.frame = tabFrame;//重置tabView的高度
}

//计算特定值
- (void)calculateSpecifiedValue{
    realTitleHeight = realOutlineHeight*standTitleHeight/standOutlineHeight;
    horizonSpliteLineBegin = CGPointMake(0, realTitleHeight-spliteLineWidth/2);
    horizonSpliteLineEnd = CGPointMake(realOutlineWidth, realTitleHeight-spliteLineWidth/2);
    verticalSpliteLineBegin = CGPointMake(realOutlineWidth/2-spliteLineWidth/2, realTitleHeight);
    verticalSpliteLineEnd = CGPointMake(realOutlineWidth/2-spliteLineWidth/2, realOutlineHeight);
}

//描绘分隔线
- (void)drawSplitLine{
    backImageView = [[UIImageView alloc]initWithFrame:self.frame];
    CGRect backImageViewFrame = backImageView.frame;
    backImageViewFrame.origin.x = 0;
    backImageViewFrame.origin.y = 0;
    backImageView.frame = backImageViewFrame;
    backImageView.backgroundColor = [UIColor clearColor];
    //开始画线
    UIGraphicsBeginImageContext(backImageView.frame.size);
    [backImageView.image drawInRect:CGRectMake(0, 0, backImageView.frame.size.width, backImageView.frame.size.height)];//
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), spliteLineWidth);//线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [ESColorUtil getColorFromHexValue:spliteLineColorHexValue].CGColor);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    //上下分割线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), horizonSpliteLineBegin.x, horizonSpliteLineBegin.y);//起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), horizonSpliteLineEnd.x, horizonSpliteLineEnd.y);//终点坐标
    //左右分割线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), verticalSpliteLineBegin.x, verticalSpliteLineBegin.y);//起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), verticalSpliteLineEnd.x, verticalSpliteLineEnd.y);//终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    backImageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//
    
    [self addSubview:backImageView];
}

//自定义Tab外框样式
- (void)customizedPhotoLibraryBtn{
    photoLibraryBtn = [[UIButton alloc]init];
    //[self addSubview:photoLibraryBtn];
}

//自定义Tab外框样式
- (void)customizedSnapshootBtn{
    snapshootBtn = [[UIButton alloc]init];
    //[self addSubview:snapshootBtn];
}

@end
