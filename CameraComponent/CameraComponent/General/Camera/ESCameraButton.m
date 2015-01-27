//
//  ESCameraButton.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraButton.h"

@implementation ESCameraButton

//-(void) drawRect:(CGRect)rect {
//    [ self.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
//    [ self.layer setBorderColor: [[UIColor grayColor] CGColor]];
//    [ self.layer setBorderWidth: 1.0];
//    [ self.layer setCornerRadius:8.0f];
//    [ self.layer setMasksToBounds:YES];
//}

#pragma mark - 自定义拍照按钮样式
/*
 * 自定义拍照按钮的初始化
 */
- (id)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if (self) {
        //设置拍照按钮的样式
        [self customizeOutlook];
        //设置拍照按钮的点击行为
        [self addTarget:self action:@selector(pickPicture) forControlEvents:UIControlEventTouchUpInside];
        //
        [self initUserOption];
        //获取当前的viewcontroller
        _locateViewController = [ESViewControllerUtil getCurrentViewController];
    }
    return(self);
}

/*
 * 自定义拍照按钮的样式
 */
- (void)customizeOutlook{
    [self setTitle:@"拍照" forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor whiteColor]];
    //self.frame = CGRectMake(10, 20, 100, 50);
}

#pragma mark - 用户配置检查
/*
 * 初始化用户配置
 */
- (void)initUserOption{
    pickPictureType = 4;
}

/*
 * 用户获取图片的方式
 * 1、通过拍照获得
 * 2、从相册获得
 */
- (void)pickPicture{
    switch (pickPictureType) {
        case 1:
            //获取方式：拍照、相册
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          //直接拍照--index: 0
                                          //从相册中获取图片--index: 1
                                          otherButtonTitles:@"直接拍照",@"从相册中获取图片",nil];
            [actionSheet showInView:_locateViewController.view];
        }
            break;
        case 2:
            //获取方式：拍照
        {}
            break;
        case 3:
            //获取方式：相册
        {}
            break;
        default:
            //do nothing
        {
            CGRect frame = [[UIScreen mainScreen] applicationFrame];//获取窗口大小
            ESCameraChoseView *cameraChoseView = [[ESCameraChoseView alloc] initWithFrame:frame];//实例ESCameraChoseView
            [[[UIApplication sharedApplication] keyWindow] addSubview:cameraChoseView];//
            [cameraChoseView showChoseTab];//展示选择的Tab
        }
            break;
    }
}

#pragma mark - 上拉菜单代理方法的实现
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
}

#pragma mark - 相机初始化及启动操作
/*
 * 初始化相机
 */
- (UIImagePickerController *)readyCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //只允许拍照，不允许录像
    //picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //允许编辑图片
    picker.allowsEditing = YES;
    picker.delegate = self;
    return(picker);
}

/*
 * 相机不存在的提示
 */
- (void)noExistCameraTip{
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"提示"
                               message:@"您的设备没有相机"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
    [alert show];
}

/*
 * 启动相机的操作
 */
- (void)launchCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//相机可用
        UIImagePickerController *picker = [self readyCamera];
        
        [_locateViewController presentViewController:picker animated:YES completion:NULL];
    }else{//不存在相机
        [self noExistCameraTip];
    }
}

#pragma mark - 拍照代理方法的实现
/*
 * 拍照结束并选择了图片
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([info[UIImagePickerControllerMediaType] isEqual:(NSString *)kUTTypeImage]) {//只对图片类型操作
        
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/*
 * 取消拍照
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
