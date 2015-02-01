//
//  ESCameraComponent.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraComponent.h"

@implementation ESCameraComponent

#pragma mark -
// 初始化
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self customizedPresetValue];
        //
        [self customizedGlobalView];
        //
        [self customizedOriginalOption];
        //自定义获取图片的按钮
        [self customizedCameraButton];
    }
    return self;
}

#pragma mark -
// 获取控件中展示的图片
- (NSArray *)getImageData{
    if(originalMark){//返回原图
        return imageData;
    }else{//对原图进行压缩
        
    }
    return nil;
}

#pragma mark - 删除图片处理
- (void)deleteImage:(UIButton *)button{
    //获取即将删除的图片
    UIImage *image = [imageData objectAtIndex:button.tag];
    NSArray *resultKeysArray = [imageDataFromPhotoLibrary allKeysForObject:image];
    if ( 1 == [resultKeysArray count] ) {//说明图片是从本地照片获得的
        //
        NSString *key = [resultKeysArray objectAtIndex:0];
        //
        [imageDataFromPhotoLibrary removeObjectForKey:key];
        //
        [cameraPicMultiPicViewController deleteImageByIndex:key];
        //
        currentPhotoLibrarySelectedCount--;
    }
    //当前选择的数量减1
    currentSelectedCount--;
    //
    [imageData removeObject:image];
}

#pragma mark - 属性设置方法
// 该方法仅在初始化之后被调用一次
- (void)configureComponentWithType:(ESPickPictureType)type maxLimitMark:(BOOL)mark maxCount:(int)count{
    if ( NO == initMark ) {
        //获取用户的配置
        //配置用户获取图片的方式
        pickPictureType = type;
        //是否限制拍照数量
        picMaxLimitMark = mark;
        //照片数量最大值
        picMaxCount = count;
        initMark = YES;
    }
}

#pragma mark - 
// 重新加载图像页面展示
- (void) reloadImageViewDisplay{
}

#pragma mark - 用户配置检查
/*
 * 用户获取图片的方式
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
    cameraPicMultiPicViewController.picMaxCount = picMaxCount-currentSelectedCount+currentPhotoLibrarySelectedCount;
    //当前已选择的图片数量
    cameraPicMultiPicViewController.currentPhotoLibrarySelectedCount = currentPhotoLibrarySelectedCount;
    
    //获取当前的viewcontroller
    currentViewController = [ESViewControllerUtil getCurrentViewController];
    //
    [currentViewController presentViewController:cameraPicMultiPicViewNavigationController animated:YES completion:nil];
}

#pragma mark - 本地照片代理方法
//
- (void) transferMultiPic:(NSMutableDictionary *)dataDictionary{
    //[dataDictionary removeObjectForKey:@"1"];
    //[cameraPicMultiPicViewController deleteImageByIndex:@"1"];
    //
    imageDataFromPhotoLibrary = dataDictionary;
    //增加新图片
    NSArray *dataIndexKey = [[dataDictionary allKeys]sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *numStr1 = obj1, *numStr2 = obj2;
        NSInteger number1 = [numStr1 integerValue], number2 = [numStr2 integerValue];
        if (number1>=number2) {
            return YES;
        }else{
            return NO;
        }
    }];
    //按顺序添加图片
    for (NSString *key in dataIndexKey) {
        [imageData addObject:[dataDictionary objectForKey:key]];
    }
    //
    currentPhotoLibrarySelectedCount = (int)[dataIndexKey count] ;
    currentSelectedCount = currentSelectedCount+currentPhotoLibrarySelectedCount;
    //刷新图片展示
    [self reloadImageViewDisplay];
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
    currentViewController = [ESViewControllerUtil getCurrentViewController];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//相机可用
        UIImagePickerController *picker = [self readyCamera];
        [currentViewController presentViewController:picker animated:YES completion:NULL];
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
        //增加新图片
        [imageData addObject:info[UIImagePickerControllerOriginalImage]];
        //已选择的图片数量加1
        currentSelectedCount++;
        //刷新图片展示
        [self reloadImageViewDisplay];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/*
 * 取消拍照
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 样式
// 预设值
- (void)customizedPresetValue{
    
    //
    CGRect frame = self.frame;
    componentOutlineSize = frame.size;
    
    //标准值
    standComponentOutlineWidth = 750;//
    standComponentOutlineHeight = 306;//
    standComponentHorizonSpan = 24;//
    standComponentVerticalSpan = 41;//
    standCameraButtonSize = CGSizeMake(192, 232);//
    
    //大小计算
    componentOutlineSize.height = componentOutlineSize.width*standComponentOutlineHeight/standComponentOutlineWidth;
    frame.size = componentOutlineSize;
    self.frame = frame;
    
    componentHorizonSpan = componentOutlineSize.width*standComponentHorizonSpan/standComponentOutlineWidth;//
    componentVerticalSpan = componentOutlineSize.width*standComponentVerticalSpan/standComponentOutlineWidth;//
    cameraButtonSize = CGSizeMake(componentOutlineSize.width*standCameraButtonSize.width/standComponentOutlineWidth, componentOutlineSize.width*standCameraButtonSize.height/standComponentOutlineWidth);
    
    //位置计算
    cameraButtonPoint = CGPointMake(0, 0);
    
    //
    initMark = NO;
    currentSelectedCount = 0;
    imageData = [[NSMutableArray alloc]init];
}

// 全局view
- (void)customizedGlobalView{
    self.backgroundColor = [UIColor purpleColor];
}

// 原图选项的按钮
- (void)customizedOriginalOption{
}

// 获取图片的按钮
- (void)customizedCameraButton{
    cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(cameraButtonPoint.x, cameraButtonPoint.y, cameraButtonSize.width, cameraButtonSize.height)];
    cameraButton.backgroundColor = [UIColor yellowColor];
    //设置拍照按钮的点击行为
    [cameraButton addTarget:self action:@selector(pickPicture) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraButton];
}

@end