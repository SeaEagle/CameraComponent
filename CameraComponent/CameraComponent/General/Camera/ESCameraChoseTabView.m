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

@synthesize photoLibraryBtn;
@synthesize snapshootBtn;

#pragma mark - 初始化
//初始化
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化标准值
        [self customizedStandValue];
        //初始化TabView最外框样式
        [self customizedOutlineStyle];
        //根据对比值计算其他参数值
        [self calculateSpecifiedValue];
        //描绘TabView线条背景图
        [self drawSplitLine];
        //
        [self customizedTipLabel];
        //
        [self customizedButton];
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
    spliteLineColorHexValue = @"28a8e3";//
    standHorizonSpliteLineSpan = 24.0;//
    standVerticalSpliteLineSpan = 40.0;//
    standButtonHeight = 180.0;//
    standButtonWidth = 250.0;//
    tipLabelFontColorHexValue = @"28a8e3";//
    standTipFontSize = 42.0;//
    buttonLabelFontColorHexValue = @"28a8e3";
    standPhotoLibraryLabFontSize = 51.0;//
    standSnapshootLabFontSize = 51.0;//
    standPhotoLibraryImgViewSize = 150;//
    standSnapshootImgViewSize = 150;//
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
    realTitleHeight = realOutlineHeight*standTitleHeight/standOutlineHeight;//
}

//描绘分隔线
- (void)drawSplitLine{
    //线条背景图
    backImageView = [[UIImageView alloc]initWithFrame:self.frame];
    CGRect backImageViewFrame = backImageView.frame;
    backImageViewFrame.origin.x = 0;
    backImageViewFrame.origin.y = 0;
    backImageView.frame = backImageViewFrame;
    backImageView.backgroundColor = [UIColor clearColor];
    //线条端点计算
    horizonSpliteLineSpan = realOutlineWidth*standHorizonSpliteLineSpan/standOutlineWidth;
    //
    horizonSpliteLineBegin = CGPointMake(horizonSpliteLineSpan, realTitleHeight-spliteLineWidth/2);
    horizonSpliteLineEnd = CGPointMake(realOutlineWidth-horizonSpliteLineSpan, realTitleHeight-spliteLineWidth/2);
    //
    verticalSpliteLineSpan = realOutlineHeight*standVerticalSpliteLineSpan/standOutlineHeight;
    //
    verticalSpliteLineBegin = CGPointMake(realOutlineWidth/2, realTitleHeight+verticalSpliteLineSpan);
    verticalSpliteLineEnd = CGPointMake(realOutlineWidth/2, realOutlineHeight-verticalSpliteLineSpan);
    //画线-Begin
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
    UIGraphicsEndImageContext();
    //画线-end
    [self addSubview:backImageView];
}

//自定义提示label样式
- (void)customizedTipLabel{
    CGRect tipLabelFrame = CGRectMake(0, 0, realOutlineWidth, realTitleHeight-spliteLineWidth);
    realTipFontSize = realOutlineHeight*standTipFontSize/standOutlineHeight;
    tipLabel = [[UILabel alloc]initWithFrame:tipLabelFrame];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"请选择";
    tipLabel.textColor = [ESColorUtil getColorFromHexValue: tipLabelFontColorHexValue];
    UIFont *currentFont = tipLabel.font;
    tipLabel.font = [UIFont fontWithName:currentFont.fontName size:realTipFontSize];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:tipLabel];
}

//
- (void)customizedButton{
    [self calculateButtonReleatedPoint];//
    [self customizedPhotoLibraryImg];//
    [self customizedPhotoLibraryLabel];//
    [self customizedSnapshootImg];//
    [self customizedSnapshootLabel];//
    [self customizedPhotoLibraryBtn];//
    [self customizedSnapshootBtn];//
}

//
- (void)calculateButtonReleatedPoint{
    //图片
    photoLibraryImgViewSize = realOutlineHeight*standPhotoLibraryImgViewSize/standOutlineHeight;
    snapshootImgViewSize = realOutlineHeight*standSnapshootImgViewSize/standOutlineHeight;
    //图片定位
    photoLibraryImgPoint = CGPointMake((realOutlineWidth/2-spliteLineWidth/2-photoLibraryImgViewSize)/2, (realOutlineHeight-photoLibraryImgViewSize)/2);
    snapshootImgPoint = CGPointMake(realOutlineWidth-(realOutlineWidth/2-spliteLineWidth/2+snapshootImgViewSize)/2, (realOutlineHeight-snapshootImgViewSize)/2);
    
    //文字label
    realPhotoLibraryLabFontSize = realOutlineHeight*standPhotoLibraryLabFontSize/standOutlineHeight;//
    photoLibraryLabelSize = CGSizeMake((realOutlineWidth-spliteLineWidth)/2, realPhotoLibraryLabFontSize);//
    realSnapshootLabFontSize = realOutlineHeight*standSnapshootLabFontSize/standOutlineHeight;//
    snapshootLabelSize = CGSizeMake((realOutlineWidth-spliteLineWidth)/2, realSnapshootLabFontSize);//
    //文字label位置定位
    photoLibraryLabelPoint = CGPointMake(0, (realOutlineHeight+photoLibraryImgPoint.y+photoLibraryImgViewSize-photoLibraryLabelSize.height)/2);
    snapshootLabelPoint = CGPointMake((realOutlineWidth+spliteLineWidth)/2, (realOutlineHeight+snapshootImgPoint.y+snapshootImgViewSize-snapshootLabelSize.height)/2);
    
    //button
    realButtonHeight = realOutlineHeight*standButtonHeight/standOutlineHeight;//
    realButtonWidth = realOutlineWidth*standButtonWidth/standOutlineWidth;//
    buttonPointHeight = (realOutlineHeight-realTitleHeight-spliteLineWidth/2-realButtonHeight)/2+realTitleHeight;//
    leftButtonPoint = (realOutlineWidth/2-spliteLineWidth/2-realButtonWidth)/2;
    rightButtonPoint = leftButtonPoint+(realOutlineWidth+spliteLineWidth)/2;
    //button位置定位
    photoLibraryPoint = CGPointMake(leftButtonPoint, buttonPointHeight);
    snapshootPoint = CGPointMake(rightButtonPoint, buttonPointHeight);
}

//
- (void)customizedPhotoLibraryImg{
    photoLibraryImg = [UIImage imageNamed:@"photoLibraryBtn"];
    CGRect photoLibraryImgFrame = CGRectMake(photoLibraryImgPoint.x, photoLibraryImgPoint.y, photoLibraryImgViewSize, photoLibraryImgViewSize);
    photoLibraryImgView = [[UIImageView alloc]initWithFrame:photoLibraryImgFrame];
    photoLibraryImgView.backgroundColor = [UIColor clearColor];
    photoLibraryImgView.image = photoLibraryImg;
    [self addSubview:photoLibraryImgView];
}

//
- (void)customizedPhotoLibraryLabel{
    //描绘按钮背景label
    CGRect photoLibraryLabFrame = CGRectMake(photoLibraryLabelPoint.x, photoLibraryLabelPoint.y, photoLibraryLabelSize.width, photoLibraryLabelSize.height);
    photoLibraryLabel = [[UILabel alloc]initWithFrame:photoLibraryLabFrame];
    photoLibraryLabel.textAlignment = NSTextAlignmentCenter;
    photoLibraryLabel.text = @"本地照片";
    photoLibraryLabel.textColor = [ESColorUtil getColorFromHexValue: buttonLabelFontColorHexValue];
    UIFont *currentFont = photoLibraryLabel.font;
    photoLibraryLabel.font = [UIFont fontWithName:currentFont.fontName size:realPhotoLibraryLabFontSize];
    photoLibraryLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: photoLibraryLabel];
}

//
- (void)customizedSnapshootImg{
    snapshootImg = [UIImage imageNamed:@"snapshootBtn"];
    CGRect snapshootImgFrame = CGRectMake(snapshootImgPoint.x, snapshootImgPoint.y, snapshootImgViewSize, snapshootImgViewSize);
    snapshootImgView = [[UIImageView alloc]initWithFrame:snapshootImgFrame];
    snapshootImgView.backgroundColor = [UIColor clearColor];
    snapshootImgView.image = snapshootImg;
    [self addSubview:snapshootImgView];
}

//自定义
- (void)customizedPhotoLibraryBtn{
    //设置按钮覆盖背景
    CGRect photoLibraryBtnFrame = CGRectMake(photoLibraryPoint.x, photoLibraryPoint.y, realButtonWidth, realButtonHeight);
    photoLibraryBtn = [[UIButton alloc]initWithFrame:photoLibraryBtnFrame];
    photoLibraryBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:photoLibraryBtn];
}

//
- (void)customizedSnapshootLabel{
    //描绘按钮背景label
    CGRect snapshootLabFrame = CGRectMake(snapshootLabelPoint.x, snapshootLabelPoint.y, snapshootLabelSize.width, snapshootLabelSize.height);
    snapshootLabel = [[UILabel alloc]initWithFrame:snapshootLabFrame];
    snapshootLabel.textAlignment = NSTextAlignmentCenter;
    snapshootLabel.text = @"拍照";
    snapshootLabel.textColor = [ESColorUtil getColorFromHexValue: buttonLabelFontColorHexValue];
    UIFont *currentFont = snapshootLabel.font;
    snapshootLabel.font = [UIFont fontWithName:currentFont.fontName size:realSnapshootLabFontSize];
    snapshootLabel.backgroundColor = [UIColor clearColor];
    [self addSubview: snapshootLabel];
}

//自定义
- (void)customizedSnapshootBtn{
    //设置按钮覆盖背景
    CGRect snapshootBtnFrame = CGRectMake(snapshootPoint.x, snapshootPoint.y, realButtonWidth, realButtonHeight);
    snapshootBtn = [[UIButton alloc]initWithFrame:snapshootBtnFrame];
    snapshootBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:snapshootBtn];
}

@end
