//
//  ESCameraMultiPicScanViewController.h
//  CameraComponent
//
//  Created by SeaEagle on 15/1/29.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ESImageUtil.h"

@protocol ESScanAndPickCommunicateDelegate <NSObject>
@required
- (void) managePictureState:(NSInteger)index selectedCount:(int)count;
@end

@interface ESCameraMultiPicScanViewController : UIViewController
{
    //业务数据
    BOOL picMaxLimitMark;//图片数量限制标记, YES:限制图片数量, NO:不限制图片数量
    int picMaxCount;//图片数量最大值
    int currentSelectedCount;//已选择的数量
    
    //
    BOOL scanMark;//YES:浏览所有的图片, NO:浏览选中的图片
    ALAssetsLibrary *library;//相册
    NSMutableArray *photoUrlData;//图片数组
    NSInteger currentIndex;//当前图片索引
    NSMutableArray *photoSelectState;//选择状态, 0表示不选中, 1表示选中
    
    //
    UIBarButtonItem *rightSelectItem;//导航栏右上角按钮
    
    //中部显示大图
    CGSize originalImageViewSize;//查看原图视图的大小
    CGPoint originalImageViewPoint;//查看原图视图的位置
    UIImageView *originalImageView;//查看原图视图
    
    //底部工具栏
    CGFloat standToolBarWidth;//标准工具栏宽度
    CGFloat standToolBarHeight;//标准工具栏高度
    CGSize toolBarSize;//底部工具栏的大小
    CGPoint toolBarPoint;//底部工具栏的位置
    UIView *toolBarView;//底部工具栏
    CGFloat standToolbarButtonSpan;//
    CGFloat toolbarButtonSpan;//
    CGFloat toolbarButtonFontSize;//工具栏上按钮的字体大小
    CGSize finishButtonSize;//
    CGPoint finishButtonPoint;//
    UIButton *finishButton;//完成按钮-位于底部工具栏-右边
    
    //手势
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
    
    //图片
    UIImage *selectedImg;//选择背景图
    UIImage *noSelectedImg;//未选择背景图
}

#pragma mark - 属性说明
@property(strong, nonatomic) id <ESScanAndPickCommunicateDelegate> scanAndPickCommunicateDelegate;//
@property BOOL picMaxLimitMark;//图片数量限制标记
@property int picMaxCount;//图片数量最大值
@property int currentSelectedCount;//已选择的数量
@property BOOL scanMark;//浏览标识
@property NSMutableArray *photoUrlData;//图片数组
@property NSMutableArray *photoSelectState;//选择状态
@property NSInteger currentIndex;//当前图片索引

#pragma mark - 方法声明


@end
