//
//  ESCameraButton.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraButton.h"

@implementation ESCameraButton

#pragma mark - 属性声明
@synthesize locateViewController;
@synthesize pickPictureType;//获取图片的方式（可配置项）
@synthesize picMaxLimitMark;//图片数量限制标记, YES:限制图片数量, NO:不限制图片数量
@synthesize picMaxCount;//图片数量最大值
@synthesize currentSelectedCount;//已选择的数量

#pragma mark - 自定义拍照按钮样式
/*
 * 自定义拍照按钮的初始化
 */
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置拍照按钮的点击行为
        [self addTarget:self action:@selector(pickPicture) forControlEvents:UIControlEventTouchUpInside];
    }
    return(self);
}

#pragma mark - 用户配置检查
/*
 * 用户获取图片的方式
 * 1、通过拍照获得
 * 2、从相册获得
 */
- (void)pickPicture{
    switch (pickPictureType) {
        case ESPhotoLibraryOrCamera:
            //获取方式：拍照、相册
        {
            if( nil == cameraChoseView ){
                CGRect frame = [[UIScreen mainScreen] applicationFrame];//获取窗口大小
                cameraChoseView = [[ESCameraChoseView alloc] initWithFrame:frame];//实例ESCameraChoseView
                cameraChoseTabView = cameraChoseView.cameraChoseTabView;
                [cameraChoseTabView.photoLibraryBtn addTarget:self action:@selector(photoLibraryOperation) forControlEvents:UIControlEventTouchUpInside];
                [cameraChoseTabView.snapshootBtn addTarget:self action:@selector(snapshootOperation) forControlEvents:UIControlEventTouchUpInside];
            }
            [[[UIApplication sharedApplication] keyWindow] addSubview:cameraChoseView];//
            [cameraChoseView showChoseTab];//展示选择的Tab
        }
            break;
        case ESCamera:
            //获取方式：拍照
        {
            [self launchCamera];
        }
            break;
        case ESPhotoLibrary:
            //获取方式：相册
        {
            [self launchPhotoLibrary];
        }
            break;
        default:
            //do nothing
        {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"提示"
                                       message:@"未指定获取相片的方式"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
            [alert show];
        }
            break;
    }
}

#pragma mark - 对选择"拍照"或"本地照片"Tab中的按钮进行处理
/*
 * 本地照片按钮的处理
 */
- (void)photoLibraryOperation{
    [cameraChoseView hideChoseTab];//隐藏选择的Tab
    [cameraChoseView removeFromSuperview];//
    //打开本地照片
    [self launchPhotoLibrary];
}

/*
 * 拍照按钮的处理
 */
- (void)snapshootOperation{
    [cameraChoseView hideChoseTab];//隐藏选择的Tab
    [cameraChoseView removeFromSuperview];//
    [self launchCamera];//启动相机
}

#pragma mark - 本地照片
// 打开本地照片
- (void)launchPhotoLibrary{
    if ( nil == cameraPicMultiPicViewController ) {
        cameraPicMultiPicViewController = [[ESCameraPickMultiPicViewController alloc]init];
        cameraPicMultiPicViewController.multiPicDelegate = self;
    }
    if ( nil == cameraPicMultiPicViewNavigationController ) {
        cameraPicMultiPicViewNavigationController = [[UINavigationController alloc]initWithRootViewController:cameraPicMultiPicViewController];
    }
    
    //是否限制图片数量
    cameraPicMultiPicViewController.picMaxLimitMark = picMaxLimitMark;
    //图片数量最大值
    cameraPicMultiPicViewController.picMaxCount = picMaxCount;
    //当前已选择的图片数量
    cameraPicMultiPicViewController.currentPhotoLibrarySelectedCount = currentSelectedCount;
    //清除已选择的图片
    
    locateViewController = [ESViewControllerUtil getCurrentViewController];
    
    [locateViewController presentViewController:cameraPicMultiPicViewNavigationController animated:YES completion:nil];
}

#pragma mark - 本地照片代理方法
//
- (void) transferMultiPic{
    
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
    picker.allowsEditing = NO;
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
    //获取当前的viewcontroller
    locateViewController = [ESViewControllerUtil getCurrentViewController];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//相机可用
        UIImagePickerController *picker = [self readyCamera];
        
        [locateViewController presentViewController:picker animated:YES completion:NULL];
    }else{//不存在相机
        [self noExistCameraTip];
    }
}

#pragma mark - 相机代理方法的实现
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

#pragma mark - 组件删除图片的代理方法


@end
