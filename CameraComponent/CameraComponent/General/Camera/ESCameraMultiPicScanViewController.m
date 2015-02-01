//
//  ESCameraMultiPicScanViewController.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/29.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraMultiPicScanViewController.h"

@interface ESCameraMultiPicScanViewController ()

@end

@implementation ESCameraMultiPicScanViewController

#pragma mark - 属性说明
@synthesize picMaxLimitMark;
@synthesize picMaxCount;
@synthesize currentPhotoLibrarySelectedCount;
@synthesize scanMark;//浏览标识
@synthesize photoUrlData;//图片数组
@synthesize photoSelectState;//选择状态
@synthesize currentIndex;//当前图片索引
@synthesize photoSelectData;//存放已选择的图片索引
@synthesize currentSelectedIndex;//用于指向选中的图片的索引
@synthesize photoSelectIndexOrder;//已选择图片的顺序(升序)

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    //全局
    [self customizedGlobalView];
    //初始化值
    [self customizedPresetValue];
    //导航栏
    [self customizedNavigationBar];
    //查看原图
    [self customizedOriginalImageView];
    //工具栏
    [self customizedToolBar];
    //手势
    [self customizedSwipeGestureRecognizer];
}

// 刷新界面显示内容
- (void)viewDidAppear:(BOOL)animated{
    // 展示当前选中的图片
    if ( NO == scanMark) {
        currentIndex = [[photoSelectIndexOrder objectAtIndex:currentSelectedIndex] integerValue];
    }
    [self showImage:currentIndex];
}

// 页面关闭时
- (void)viewWillDisappear:(BOOL)animated{
    originalImageView.image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 手势处理
// 手势初始化
- (void)customizedSwipeGestureRecognizer{
    if( nil == leftSwipeGestureRecognizer ){
        leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftDirection)];
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    }
    if( nil == rightSwipeGestureRecognizer ){
        rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightDirection)];
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    }
}

// 向左滑动
- (void)leftDirection{
    if (scanMark) {//浏览所有图片
        if ( [photoUrlData count] > (currentIndex+1)) {
            currentIndex++;
        }
    }else{//浏览选中的图片
        if ( [photoSelectIndexOrder count] > (currentSelectedIndex+1) ) {
            currentSelectedIndex++;
            currentIndex = [[photoSelectIndexOrder objectAtIndex:currentSelectedIndex] integerValue];
        }
    }
    // 展示下一张的图片
    [self showImage:currentIndex];
}

// 向右滑动
- (void)rightDirection{
    if (scanMark) {//浏览所有图片
        if ( 0 < currentIndex ) {
            currentIndex--;
        }
    }else{//浏览选中的图片
        if ( 0 < currentSelectedIndex ) {
            currentSelectedIndex--;
            currentIndex = [[photoSelectIndexOrder objectAtIndex:currentSelectedIndex] integerValue];
        }
    }
    // 展示上一张选中的图片
    [self showImage:currentIndex];
}

#pragma mark - 通过代理通知当前选择的数量以及图片的状态
//
- (void)scanAndPickCommuniccate{
    if([self.scanAndPickCommunicateDelegate respondsToSelector:@selector(managePictureState:selectedCount:)]){
        [self.scanAndPickCommunicateDelegate managePictureState:currentIndex selectedCount:currentPhotoLibrarySelectedCount];
    }
}

#pragma mark - 按钮操作
// 处理选中与不选中
- (void)selectOrNotOperation{
    NSNumber *state = [photoSelectState objectAtIndex:currentIndex];
    if ( 0 == [state intValue] ) {//不选中变为选中
        if (picMaxLimitMark && picMaxCount <= currentPhotoLibrarySelectedCount ) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"提示"
                                       message:[NSString stringWithFormat:@"最多只能选择%d图片", picMaxCount]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
            [alert show];
        }else{
            [rightButton setImage:selectedImg forState:UIControlStateNormal];;//修改背景图
            state = [NSNumber numberWithInt:1];//修改状态
            currentPhotoLibrarySelectedCount++;
            [photoSelectData setObject:[NSString stringWithFormat:@"%ld", currentIndex] forKey:[NSString stringWithFormat:@"%ld", currentIndex]];
        }
    }else{//选中变为不选中
        [rightButton setImage:noSelectedImg forState:UIControlStateNormal];;//修改背景图
        state = [NSNumber numberWithInt:0];//修改状态
        currentPhotoLibrarySelectedCount--;
        [photoSelectData removeObjectForKey:[NSString stringWithFormat:@"%ld", currentIndex]];
    }
    //修改已选图片数量提示
    [self changeCurrentSelectedCountTip:currentPhotoLibrarySelectedCount];
    //修改状态
    [photoSelectState replaceObjectAtIndex:currentIndex withObject:state];
    //通知代理
    [self scanAndPickCommuniccate];
}

// 完成返回上一层
- (void)finishOperation{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 图片操作
// 显示图片
- (void)showImage:(NSInteger)index{
    NSNumber *state = [photoSelectState objectAtIndex:currentIndex];
    if ( 0 == [state intValue] ) {//不选中
        [rightButton setImage:noSelectedImg forState:UIControlStateNormal];;//修改背景图
    }else{//选中
        [rightButton setImage:selectedImg forState:UIControlStateNormal];;//修改背景图
    }
    [library assetForURL:[photoUrlData objectAtIndex:currentIndex]
             resultBlock:^(ALAsset *result){
                 originalImageView.image = [ESImageUtil shrinkImage:[self getOriginalPicture:result] toSize:originalImageViewSize];
             }
            failureBlock:^(NSError *error){
            }
     ];
}

// 返回原图
- (UIImage *)getOriginalPicture:(ALAsset *)data{
//    UIImage *fullImage = [UIImage imageWithCGImage:[data.defaultRepresentation fullScreenImage]
//                                             scale:[data.defaultRepresentation scale]
//                                       orientation:(UIImageOrientation)[data.defaultRepresentation orientation]];
    UIImage *fullImage = [UIImage imageWithCGImage:[[data defaultRepresentation]fullScreenImage]];
    return fullImage;
}

#pragma mark - 样式
// 全局
- (void)customizedGlobalView{
    //view背景色
    self.view.backgroundColor = [UIColor clearColor];
}

// 预设值
- (void)customizedPresetValue{
    //初始化相册
    library = [[ALAssetsLibrary alloc]init];
    
    //获取应用运行窗口大小;
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    //标准值设置
    standToolBarWidth = 750;//
    standToolBarHeight = 110;//
    standToolbarButtonSpan = 15;//
    
    //大小计算
    //工具栏大小
    toolBarSize = CGSizeMake(frame.size.width, frame.size.width*standToolBarHeight/standToolBarWidth);//
    //图片视图的大小
    originalImageViewSize = frame.size;
    originalImageViewSize.height = originalImageViewSize.height - toolBarSize.height - self.navigationController.navigationBar.bounds.size.height;
    //
    toolbarButtonSpan = toolBarSize.width*standToolbarButtonSpan/standToolBarWidth;
    //工具栏的完成按钮大小
    finishButtonSize = CGSizeMake(toolBarSize.width/7, toolBarSize.height);
    //
    currentSelectedCountLabelSize = CGSizeMake(toolBarSize.width-finishButtonSize.width-2*toolbarButtonSpan, toolBarSize.height);
    //工具栏按钮的字体大小
    toolbarButtonFontSize = toolBarSize.height*0.37;
    
    //位置计算
    originalImageViewPoint = CGPointMake(0, 0);
    toolBarPoint = CGPointMake(0, originalImageViewSize.height);
    //
    finishButtonPoint = CGPointMake(toolBarSize.width-toolbarButtonSpan-finishButtonSize.width, 0);
    //
    currentSelectedCountLabelPoint = CGPointMake(toolbarButtonSpan, 0);
    
    //图片
    //选中
    selectedImg = [UIImage imageNamed:@"selected@3x.png"];
    //未选中
    noSelectedImg = [UIImage imageNamed:@"noSelected@3x.png"];
}

// 导航栏
- (void)customizedNavigationBar{
    //导航栏不隐藏
    self.navigationController.navigationBarHidden = NO;
    //导航栏不透明
    self.navigationController.navigationBar.translucent = NO;
    //导航栏右边的选中与不选中处理
    //rightSelectItem = [[UIBarButtonItem alloc] initWithImage:noSelectedImg style:UIBarButtonItemStylePlain target:self action:@selector(selectOrNotOperation)];
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, toolBarSize.height*0.6, toolBarSize.height*0.6);
    [rightButton setImage:noSelectedImg forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(selectOrNotOperation) forControlEvents:UIControlEventTouchUpInside];
    rightSelectItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightSelectItem;
}

// 原图视图
- (void)customizedOriginalImageView{
    originalImageView =  [[UIImageView alloc]initWithFrame:CGRectMake(originalImageViewPoint.x, originalImageViewPoint.y, originalImageViewSize.width, originalImageViewSize.height)];
    originalImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:originalImageView];
}

// 工具栏样式
- (void)customizedToolBar{
    toolBarView = [[UIView alloc]initWithFrame:CGRectMake(toolBarPoint.x, toolBarPoint.y, toolBarSize.width, toolBarSize.height)];
    toolBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolBarView];
    //
    finishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    finishButton.frame = CGRectMake(finishButtonPoint.x, finishButtonPoint.y, finishButtonSize.width, finishButtonSize.height);
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    finishButton.titleLabel.font = [UIFont systemFontOfSize:toolbarButtonFontSize];
    [finishButton addTarget:self action:@selector(finishOperation) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:finishButton];
    //工具条上的多少张图片
    currentSelectedCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(currentSelectedCountLabelPoint.x, currentSelectedCountLabelPoint.y, currentSelectedCountLabelSize.width, currentSelectedCountLabelSize.height)];
    currentSelectedCountLabel.textAlignment = NSTextAlignmentRight;
    currentSelectedCountLabel.font = [UIFont systemFontOfSize:toolbarButtonFontSize];
    currentSelectedCountLabel.textColor = finishButton.tintColor;
    [self changeCurrentSelectedCountTip:currentPhotoLibrarySelectedCount];
    [toolBarView addSubview:currentSelectedCountLabel];
}

// 更新已选择的图片数量提示
- (void)changeCurrentSelectedCountTip:(int)count{
    if( 0 == count ){
        currentSelectedCountLabel.text = @"";
    }else{
        currentSelectedCountLabel.text = [NSString stringWithFormat:@"%d", currentPhotoLibrarySelectedCount];
    }
}
@end
