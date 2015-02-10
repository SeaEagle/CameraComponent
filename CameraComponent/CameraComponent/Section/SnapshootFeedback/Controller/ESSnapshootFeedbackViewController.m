//
//  SnapshootFeedbackViewController.m
//  CameraComponent
//
//  Created by SeaEagle on 15/2/9.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootFeedbackViewController.h"

@interface ESSnapshootFeedbackViewController ()

@end

@implementation ESSnapshootFeedbackViewController

#pragma mark - 初始化操作
// storyboard初始化
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

//
- (void)viewDidLoad {
    [super viewDidLoad];
    // 相机初始化
    [self initCameraComponent];
}

//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 相机初始化
- (void)initCameraComponent{
    // 设定拍照控件的大小
    CGRect frame = _snapshootView.frame;
    CGRect outline = [[UIScreen mainScreen]bounds];
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = outline.size.width;
    // 声明拍照组件
    cameraComponent = [[ESCameraComponent alloc]initWithFrame:frame];
    // 指定获取相片的方式, 是否限制拍照数量, 拍照数量最大值
    [cameraComponent configureComponentWithType:ESPhotoLibraryOrCamera maxLimitMark:YES maxCount:5];
    // 添加到保存拍照控件的容器视图
    [_snapshootView addSubview:cameraComponent];
}

#pragma mark - 跳转处理
// 跳转之前的准备
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SnapshootTheme"]){//拍照主题
        
    }else if([segue.identifier isEqualToString:@"SnapshootRecords"]){//拍照记录
        
    }
}

#pragma mark - 键盘处理
- (IBAction)editBegin:(id)sender {
    //创建一个仿射变换，平移(0, -100)视图上移100像素
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, -100);
    //使视图使用这个变换
    self.containerView.transform = pTransform;
}

- (IBAction)editEnd:(id)sender {
    [sender resignFirstResponder];
    //创建一个仿射变换，平移(0, -100)视图上移100像素
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, 0);
    //使视图使用这个变换
    self.containerView.transform = pTransform;
}


@end
