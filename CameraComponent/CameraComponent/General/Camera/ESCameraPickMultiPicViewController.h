//
//  ESCameraPickMultiPicViewController.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/28.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ESColorUtil.h"

//多图数据传递代理
@protocol PickMultiPicDelegate <NSObject>
@required
- (void) manageMultiPic;
@end

@interface ESCameraPickMultiPicViewController : UIViewController
{
    
    NSMutableArray *photoData;//图片的原始数组
    NSMutableArray *photoSelectImgViewArray;//
    NSMutableArray *photoSelectState;//选择状态, 0表示不选中, 1表示选中
    
    CGFloat pickPhotoViewRowSize;//图片视图放置的图片数量
    CGSize standPickPhotoViewPerPicSize;//图片视图每张图片的标准大小
    CGSize pickPhotoViewPerPicSize;//图片视图每张图片的实际大小
    
    CGPoint photoStarPoint;//照片的起始位置
    CGFloat horizonShift;//水平位移
    CGFloat verticalShift;//垂直位移
    
    CGPoint selectStarPoint;//适用于选择按钮及其背景图
    CGSize selectSize;//适用于选择按钮及其背景图
    UIImage *selectedImg;//选择背景图
    UIImage *noSelectedImg;//未选择背景图
    
    CGPoint scanStarPoint;//预览点击的起点
    CGSize scanSize;//预览点击框大小
    
    CGFloat standPickPhotoViewSpan;//标准与边缘距离
    CGFloat pickPhotoViewSpan;//与边缘距离
    CGFloat standPickPhotoViewHorizonSpace;//标准水平空白
    CGFloat pickPhotoViewHorizonSpace;//水平空白
    CGFloat standPickPhotoViewVerticalSpace;//标准垂直空白
    CGFloat pickPhotoViewVerticalSpace;//垂直空白
    CGSize pickPhotoViewSize;//图片视图的大小
    CGPoint pickPhotoViewPoint;//图片视图的位置
    NSString *pickPhotoViewColorHexValue;//图片视图背景色十六进制数值
    UIScrollView *pickPhotoView;//图片多选视图
    
    CGFloat standStateBarWidth;//标准状态栏宽度
    CGFloat standStateBarHeight;//标准状态栏高度
    CGSize stateBarSize;//底部状态栏的大小
    CGPoint stateBarPoint;//底部状态栏的位置
    UIView *stateBarView;//底部状态栏
    
    UIButton *scanButton;//预览按钮-位于底部状态栏-左边
    
    UIButton *finishButton;//完成按钮-位于底部状态栏-右边
}

@property(strong, nonatomic) id <PickMultiPicDelegate> multiPicDelegate;

@end
