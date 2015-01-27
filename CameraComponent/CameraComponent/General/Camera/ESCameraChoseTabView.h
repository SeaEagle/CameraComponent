//
//  ESCameraChoseTabView.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/26.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESColorUtil.h"
#import "ESImageUtil.h"

//
@interface ESCameraChoseTabView : UIView
{
    CGFloat standOutlineHeight;//
    CGFloat realOutlineHeight;//实际tab外框高度
    CGFloat standOutlineWidth;//
    CGFloat realOutlineWidth;//实际tab外框宽度
    
    CGFloat standTitleHeight;//标准label高度
    CGFloat realTitleHeight;//实际label高度
    UILabel *tipLabel;//提示label-"请选择"
    NSString *tipLabelFontColorHexValue;//label字体颜色十六进制值
    CGFloat standTipFontSize;//标准tip字体大小
    CGFloat realTipFontSize;//实际tip字体大小
    UIImageView *backImageView;//线条背景图
    
    CGFloat spliteLineWidth;//分割线的宽度
    CGFloat standHorizonSpliteLineSpan;//标准水平分割线空白
    CGFloat horizonSpliteLineSpan;//实际水平分割线空白
    CGPoint horizonSpliteLineBegin;//水平分割线起点
    CGPoint horizonSpliteLineEnd;//水平分割线终点
    CGFloat standVerticalSpliteLineSpan;//标准垂直分割线空白
    CGFloat verticalSpliteLineSpan;//实际垂直分割线空白
    CGPoint verticalSpliteLineBegin;//垂直分割线起点
    CGPoint verticalSpliteLineEnd;//垂直分割线终点
    NSString *spliteLineColorHexValue;//分割线颜色十六进制数值
    
    CGFloat standButtonHeight;//标准按钮高度
    CGFloat realButtonHeight;//实际按钮高度
    CGFloat standButtonWidth;//标准按钮宽度
    CGFloat realButtonWidth;//实际按钮宽度
    CGFloat buttonPointHeight;//按钮在垂直方向的y轴距离
    CGFloat leftButtonPoint;//左边按钮位置
    CGFloat rightButtonPoint;//右边按钮位置
    NSString *buttonLabelFontColorHexValue;//按钮字体颜色十六进制值
    
    UIButton *photoLibraryBtn;//打开相册按钮
    CGPoint photoLibraryPoint;//相册按钮位置
    
    UILabel *photoLibraryLabel;//
    CGSize photoLibraryLabelSize;//
    CGPoint photoLibraryLabelPoint;//
    CGFloat standPhotoLibraryLabFontSize;//
    CGFloat realPhotoLibraryLabFontSize;//
    
    UIImage *photoLibraryImg;//
    CGFloat standPhotoLibraryImgViewSize;//
    CGFloat photoLibraryImgViewSize;//
    CGPoint photoLibraryImgPoint;//
    UIImageView *photoLibraryImgView;//
    
    UIButton *snapshootBtn;//打开相机按钮
    CGPoint snapshootPoint;//相机按钮位置
    
    UILabel *snapshootLabel;//
    CGSize snapshootLabelSize;//
    CGPoint snapshootLabelPoint;//
    CGFloat standSnapshootLabFontSize;//
    CGFloat realSnapshootLabFontSize;//
    
    UIImage *snapshootImg;//
    CGFloat standSnapshootImgViewSize;//
    CGFloat snapshootImgViewSize;//
    CGPoint snapshootImgPoint;//
    UIImageView *snapshootImgView;//
}

@property UIButton *photoLibraryBtn;
@property UIButton *snapshootBtn;

@end
