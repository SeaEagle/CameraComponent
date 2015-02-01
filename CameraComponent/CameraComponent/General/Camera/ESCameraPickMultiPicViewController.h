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
#import "ESCameraDelegate.h"
#import "ESCameraMultiPicScanViewController.h"

@interface ESCameraPickMultiPicViewController : UIViewController
<ESScanAndPickCommunicateDelegate>
{
    //业务数据
    BOOL picMaxLimitMark;//图片数量限制标记, YES:限制图片数量, NO:不限制图片数量
    int picMaxCount;//图片数量最大值
    int currentPhotoLibrarySelectedCount;//已选择的数量(这里的图片数量指的是”本地照片“中已选择的数量, 不包含"拍照"的数量)
    
    NSMutableArray *photoData;//图片的原始数组
    NSMutableArray *photoUrlData;//图片的URL
    NSMutableArray *photoSelectImgViewArray;//缩略图各自选择图image对应imageView
    NSMutableArray *photoSelectState;//选择状态, 0表示不选中, 1表示选中
    NSMutableDictionary *photoSelectData;//存放已选择的图片索引-url data
    NSMutableDictionary *photoSelectImageData;//存放已选择的图片索引-image
    
    //
    ALAssetsLibrary *library;//
    
    //导航栏
    UIImage *backButtonImg;//返回按钮背景图
    UIBarButtonItem *rightCancleItem;//右上角取消按钮
    
    //每张图片
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
    
    //图片视图
    CGFloat pickPhotoViewRowSize;//图片视图放置的图片数量
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
    
    //底部工具栏
    CGFloat standToolBarWidth;//标准工具栏宽度
    CGFloat standToolBarHeight;//标准工具栏高度
    CGSize toolBarSize;//底部工具栏的大小
    CGPoint toolBarPoint;//底部工具栏的位置
    UIView *toolBarView;//底部工具栏
    
    //工具栏按钮 - 尺寸与导航栏一致
    CGFloat toolbarButtonSpan;//
    CGFloat toolbarButtonFontSize;//工具栏上按钮的字体大小
    CGSize scanButtonSize;//
    CGPoint scanButtonPoint;//
    UIButton *scanButton;//预览按钮-位于底部工具栏-左边
    CGSize finishButtonSize;//
    CGPoint finishButtonPoint;//
    UIButton *finishButton;//完成按钮-位于底部工具栏-右边
    
    //工具栏label - 显示已选多少张图片
    CGSize currentSelectedCountLabelSize;//
    CGPoint currentSelectedCountLabelPoint;//
    UILabel *currentSelectedCountLabel;//
    
    //图片预览
    ESCameraMultiPicScanViewController *cameraMultiPicScanViewController;
}

#pragma mark - 属性说明
@property(strong, nonatomic) id <ESPickMultiPicDelegate> multiPicDelegate;//
@property BOOL picMaxLimitMark;//
@property int picMaxCount;//
@property int currentPhotoLibrarySelectedCount;//

#pragma mark - 方法说明
//
- (void) deleteImageByIndex:(NSString *)index;

@end