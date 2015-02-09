//
//  SnapshootFeedbackViewController.m
//  CameraComponent
//
//  Created by SeaEagle on 15/2/9.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "SnapshootFeedbackViewController.h"

@interface SnapshootFeedbackViewController ()

@end

@implementation SnapshootFeedbackViewController

// storyboard初始化
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = _snapshootView.frame;
    frame.size.height = 2*frame.size.height;
    _snapshootView.frame = frame;
    
    CGRect outline = [[UIScreen mainScreen]bounds];
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = outline.size.width;
    
    //声明拍照组件
    ESCameraComponent *cameraComponent = [[ESCameraComponent alloc]initWithFrame:frame];
    //指定获取相片的方式, 是否限制拍照数量, 拍照数量最大值
    [cameraComponent configureComponentWithType:ESPhotoLibraryOrCamera maxLimitMark:YES maxCount:7];
    //添加到view
    [_snapshootView addSubview:cameraComponent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
