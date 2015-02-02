//
//  ESCameraComponent.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/20.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraComponent.h"

@implementation ESCameraComponent

#pragma mark - 初始化
// 初始化
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //预设值
        [self customizedPresetValue];
        //全局样式
        [self customizedGlobalView];
        //控件标志
        [self customizedComponentSign];
        //原图操作
        [self customizedOriginalOption];
        //
        [self customizedPictureContainer];
        //自定义获取图片的按钮
        [self customizedCameraButton];
        //
        [self updateImageViewDisplay];
    }
    return self;
}

#pragma mark - 其他
// 获取控件中展示的图片
- (NSArray *)getImageData{
    if(originalMark){//返回原图
        return imageData;
    }else{//对原图进行压缩
        
    }
    return nil;
}

#pragma mark - 按钮处理
//删除图片处理 - 需要调整
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
    //从已有的数据中清除
    [imageData removeObject:image];
    //更新页面显示
    [self updateImageViewDisplay];
}

//点击原图按钮的操作
- (void)originalButtonOperation{
    if(originalMark){//已选择了使用原图
        //转为不使用原图
        originalButtonImageVIew.image = noOriginalOption;
        originalMark = NO;
    }else{//没选择原图
        //转为使用原图
        originalButtonImageVIew.image = originalOption;
        originalMark = YES;
    }
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
- (void) updateImageViewDisplay{
    //清除所有subview
    NSArray *subviewArray = [imageScrollView subviews];
    for (UIView *subview in subviewArray) {
        [subview removeFromSuperview];
    }
    //
    int currentColumn=1, currentRow=1;
    //显示已添加的图片
    for (UIImage *image in imageData) {
        if (currentColumn>imageScrollViewRowSize) {//换行
            currentRow = currentRow+1;
            currentColumn = 1;
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageStartPoint.x+(currentColumn-1)*imageHorizonShift, imageStartPoint.y+(currentRow-1)*imageVerticalShift, cameraButton.bounds.size.width, cameraButton.bounds.size.height)];
        imageView.image = [ESImageUtil shrinkImage:image toSize:cameraButton.bounds.size];
        [imageScrollView addSubview:imageView];
        
        UIImageView *delImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageStartPoint.x+(currentColumn-1)*imageHorizonShift+imageView.bounds.size.width*0.7, (currentRow-1)*imageVerticalShift, imageView.bounds.size.width*0.3, imageView.bounds.size.width*0.3)];
        delImageView.image = delPicButtonImage;
        [imageScrollView addSubview:delImageView];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(imageStartPoint.x+(currentColumn-1)*imageHorizonShift+imageView.bounds.size.width*0.7, (currentRow-1)*imageVerticalShift, imageView.bounds.size.width*0.3, imageView.bounds.size.width*0.3)];
        button.tag = (currentRow-1)*imageScrollViewRowSize+currentColumn-1;
        [button addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        [imageScrollView addSubview:button];
        
        currentColumn = currentColumn+1;//指向下一列
    }
    //是否增加添加图片的按钮
    if( (YES == picMaxLimitMark && currentSelectedCount<picMaxCount) || NO == picMaxLimitMark ){
        if (currentColumn>imageScrollViewRowSize) {//换行
            currentRow = currentRow+1;
            currentColumn = 1;
        }
        
        cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(imageStartPoint.x+(currentColumn-1)*imageHorizonShift, imageStartPoint.y+(currentRow-1)*imageVerticalShift, cameraButtonSize.width, cameraButtonSize.height)];
        //设置按钮背景图
        [cameraButton setImage:[ESImageUtil shrinkImage:cameraButtonImage toSize:cameraButtonSize] forState:UIControlStateNormal];
        //设置拍照按钮的点击行为
        [cameraButton addTarget:self action:@selector(pickPicture) forControlEvents:UIControlEventTouchUpInside];
        
        [imageScrollView addSubview:cameraButton];
    }
    CGRect scrollViewFrame = imageScrollView.frame;
    scrollViewFrame.size.height = currentRow*imageVerticalShift;
    imageScrollView.frame = scrollViewFrame;
    
    CGRect outlineFrame = self.frame;
    outlineFrame.size.height = scrollViewFrame.size.height+2*componentVerticalSpan+titleHeight;
    self.frame = outlineFrame;
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
                [cameraChoseView.globalButton addTarget:self action:@selector(hideTheChoseTab) forControlEvents:UIControlEventTouchUpInside];
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

- (void)hideTheChoseTab{
    [cameraChoseView hideChoseTab];//隐藏选择的Tab
    [cameraChoseView removeFromSuperview];//
}

/*
 * 本地照片按钮的处理
 */
- (void)photoLibraryOperation{
    [self hideTheChoseTab];
    //打开本地照片
    [self launchPhotoLibrary];
}

/*
 * 拍照按钮的处理
 */
- (void)snapshootOperation{
    [self hideTheChoseTab];
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

#pragma mark - 本地照片代理方法 - 需要调整
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
    
    //
    NSArray *dataValue = [dataDictionary allValues];
    NSMutableArray *delImageArray = [[NSMutableArray alloc]init];
    for (UIImage *image in imageDataFromPhotoLibraryCache) {
        if (NO == [dataValue containsObject:image]) {
            [delImageArray addObject:image];
        }
    }
    for (UIImage *image in delImageArray) {
        [imageDataFromPhotoLibraryCache removeObject:image];
        [imageData removeObject:image];
        currentPhotoLibrarySelectedCount--;
        currentSelectedCount--;
    }
    [delImageArray removeAllObjects];
    delImageArray = nil;
    
    //按顺序添加图片
    for (NSString *key in dataIndexKey) {
        if( NO == [imageData containsObject:[dataDictionary objectForKey:key]]){
            [imageData addObject:[dataDictionary objectForKey:key]];//
            [imageDataFromPhotoLibraryCache addObject:[dataDictionary objectForKey:key]];
            currentPhotoLibrarySelectedCount++;
            currentSelectedCount++;
        }
    }
    //刷新图片展示
    [self updateImageViewDisplay];
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
        [self updateImageViewDisplay];
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
    standComponentHorizonSpan = 15;//
    standComponentVerticalSpan = 20;//
    standOriginalOptionSize = CGSizeMake(189, 69);
    standCameraButtonSize = CGSizeMake(192, 232);//
    imageScrollViewRowSize = 5;//每行显示的图片数量
    originalMark = NO;//默认不使用原图
    cameraComponentLabelFontColorHexValue = @"28a8e3";
    
    //大小计算
    //水平间隔
    componentHorizonSpan = componentOutlineSize.width*standComponentHorizonSpan/standComponentOutlineWidth;//
    //垂直间隔
    componentVerticalSpan = componentOutlineSize.width*standComponentVerticalSpan/standComponentOutlineWidth;//
    //原图操作的大小
    originalOptionSize = CGSizeMake(componentOutlineSize.width*(standOriginalOptionSize.width/1.5)/standComponentOutlineWidth, componentOutlineSize.width*(standOriginalOptionSize.height/1.5)/standComponentOutlineWidth);
    //组件头部的高度与原图操作的高度保持一致
    titleHeight = originalOptionSize.height;
    //
    cameraComponentImageSize = CGSizeMake(titleHeight, titleHeight);
    //
    cameraComponentLabelSize = CGSizeMake(componentOutlineSize.width-3*componentHorizonSpan-originalOptionSize.width-cameraComponentImageSize.width, titleHeight);
    //
    imageScrollViewSize = CGSizeMake(componentOutlineSize.width-2*componentHorizonSpan, titleHeight);
    //获取图片按钮
    CGFloat cameraButtonWidth = (imageScrollViewSize.width-(imageScrollViewRowSize-1)*componentHorizonSpan)/imageScrollViewRowSize;
    cameraButtonSize = CGSizeMake(cameraButtonWidth, cameraButtonWidth*standCameraButtonSize.height/standCameraButtonSize.width);
    //
    imageHorizonShift = componentHorizonSpan+cameraButtonSize.width;
    //
    imageVerticalShift = componentVerticalSpan+cameraButtonSize.height;
    
    //位置计算
    //
    cameraComponentImagePoint = CGPointMake(componentHorizonSpan, componentVerticalSpan);
    //
    cameraComponentLabelPoint = CGPointMake(componentHorizonSpan+cameraComponentImageSize.width+componentHorizonSpan, componentVerticalSpan);
    //
    originalOptionPoint = CGPointMake(componentOutlineSize.width-originalOptionSize.width-componentHorizonSpan, componentVerticalSpan);
    //获取图片按钮
    cameraButtonPoint = CGPointMake(componentHorizonSpan, componentVerticalSpan);
    //
    imageScrollViewPoint = CGPointMake(componentHorizonSpan, componentVerticalSpan+titleHeight);
    //
    imageStartPoint = CGPointMake(0, componentVerticalSpan);
    
    //
    initMark = NO;
    currentSelectedCount = 0;
    imageDataFromPhotoLibraryCache = [[NSMutableArray alloc]init];
    imageData = [[NSMutableArray alloc]init];
    
    //图像
    cameraComponentImage = [UIImage imageNamed:@"camera@3x.png"];
    cameraButtonImage = [UIImage imageNamed:@"cameraBtn@3x.png"];
    originalOption = [UIImage imageNamed:@"originalPic@3x.png"];
    noOriginalOption = [UIImage imageNamed:@"noOriginalPic@3x.png"];
    delPicButtonImage = [UIImage imageNamed:@"delPicBtn@3x.png"];
}

// 全局view
- (void)customizedGlobalView{
    self.backgroundColor = [UIColor whiteColor];
}

// 控件标志
- (void)customizedComponentSign{
    //
    cameraComponentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(cameraComponentImagePoint.x, cameraComponentImagePoint.y, cameraComponentImageSize.width, cameraComponentImageSize.height)];
    cameraComponentImageView.image = cameraComponentImage;
    [self addSubview:cameraComponentImageView];
    //
    cameraComponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(cameraComponentLabelPoint.x, cameraComponentLabelPoint.y, cameraComponentLabelSize.width, cameraComponentLabelSize.height)];
    cameraComponentLabel.font = [UIFont systemFontOfSize:cameraComponentLabelSize.height*0.6];
    cameraComponentLabel.text = @"拍照：";
    cameraComponentLabel.textAlignment = NSTextAlignmentLeft;
    cameraComponentLabel.textColor = [ESColorUtil getColorFromHexValue:cameraComponentLabelFontColorHexValue];
    [self addSubview:cameraComponentLabel];
}

// 原图选项的按钮
- (void)customizedOriginalOption{
    //
    originalButtonImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(originalOptionPoint.x, originalOptionPoint.y, originalOptionSize.width, originalOptionSize.height)];
    originalButtonImageVIew.image = noOriginalOption;
    [self addSubview:originalButtonImageVIew];
    //
    originalButton = [[UIButton alloc]initWithFrame:CGRectMake(originalOptionPoint.x, originalOptionPoint.y, originalOptionSize.width, originalOptionSize.height)];
    //
    originalButton.backgroundColor = [UIColor clearColor];
    //
    [originalButton addTarget:self action:@selector(originalButtonOperation) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:originalButton];
}

//
- (void)customizedPictureContainer{
    imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(imageScrollViewPoint.x, imageScrollViewPoint.y, imageScrollViewSize.width, imageScrollViewSize.height)];
    imageScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageScrollView];
}

// 获取图片的按钮
- (void)customizedCameraButton{
    cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(imageStartPoint.x, imageStartPoint.y, cameraButtonSize.width, cameraButtonSize.height)];
    //设置按钮背景图
    [cameraButton setImage:[ESImageUtil shrinkImage:cameraButtonImage toSize:cameraButtonSize] forState:UIControlStateNormal];
    //设置拍照按钮的点击行为
    [cameraButton addTarget:self action:@selector(pickPicture) forControlEvents:UIControlEventTouchUpInside];
    [imageScrollView addSubview:cameraButton];
}

@end