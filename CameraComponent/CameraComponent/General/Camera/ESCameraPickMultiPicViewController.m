//
//  ESCameraPickMultiPicViewController.m
//  CameraComponent
//
//  Created by SeaEagle on 15/1/28.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESCameraPickMultiPicViewController.h"

@interface ESCameraPickMultiPicViewController ()

@end

@implementation ESCameraPickMultiPicViewController

#pragma mark - 属性声明
@synthesize picMaxLimitMark;//是否限制图片数量
@synthesize picMaxCount;//图片数量最大值
@synthesize currentPhotoLibrarySelectedCount;//当前已选择数量

#pragma mark - 打开页面的操作
// 页面第一次显示时
- (void)viewDidLoad {
    [super viewDidLoad];
    //全局样式
    [self customizedGlobalView];
    //设定初始值
    [self customizedPresetValue];
    //导航栏
    [self customizedNavigationBar];
    //图片多选视图
    [self customizedPickPhotoView];
    //工具栏
    [self customizedToolBar];
    //获取本地图片
    [self getAllPhotoFromLibrary];
}

// 页面再次打开时
- (void)viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮的事件处理
// 选择或取消选择
- (void)selectOrNotEvent:(UIButton *)button{
    NSNumber *state = [photoSelectState objectAtIndex:button.tag];
    UIImageView *selectOrNotView = [photoSelectImgViewArray objectAtIndex:button.tag];
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
            selectOrNotView.image = selectedImg;
            //调整选择状态
            state = [NSNumber numberWithInt:1];
            //已选择的数量加1
            currentPhotoLibrarySelectedCount++;
            //将选择保存到缓存中
            [photoSelectDataCache addObject:[NSString stringWithFormat:@"%ld", button.tag]];
            //根据url及索引, 生成图片并保存
            [self saveImageByAlassetUrl:[photoUrlData objectAtIndex:button.tag] index:button.tag];
        }
    }else{//选中变为不选中
        selectOrNotView.image = noSelectedImg;
        //调整选择状态
        state = [NSNumber numberWithInt:0];
        //已选择的数量减1
        currentPhotoLibrarySelectedCount--;
        //将选择从缓存中去掉
        [photoSelectDataCache removeObject:[NSString stringWithFormat:@"%ld", button.tag]];
        //
        //[photoSelectImageData removeObjectForKey:[NSString stringWithFormat:@"%ld", button.tag]];
    }
    //更新选择数量的提示
    [self updateCurrentPhotoLibrarySelectedCountTip:currentPhotoLibrarySelectedCount];
    //更新图片的选择状态
    [photoSelectState replaceObjectAtIndex:button.tag withObject:state];
}

// 点击图片弹出的预览事件 -- 预览所有图片
- (void)scanEvent:(UIButton *)button{
    if( nil == cameraMultiPicScanViewController ){
        cameraMultiPicScanViewController = [[ESCameraMultiPicScanViewController alloc]init];
        //
        cameraMultiPicScanViewController.scanAndPickCommunicateDelegate = self;
    }
    //图片数量限制标记
    cameraMultiPicScanViewController.picMaxLimitMark = picMaxLimitMark;
    //图片数量最大值
    cameraMultiPicScanViewController.picMaxCount = picMaxCount;
    //标识浏览所有图片
    cameraMultiPicScanViewController.scanMark = YES;
    //传递照片数据
    cameraMultiPicScanViewController.photoUrlData = photoUrlData;
    //设置索引,从索引处开始浏览图片
    cameraMultiPicScanViewController.currentIndex = button.tag;
    //图片选择状态
    cameraMultiPicScanViewController.photoSelectState = photoSelectState;
    //
    //cameraMultiPicScanViewController.photoSelectData = photoSelectData;
    //已选择图片的数量
    cameraMultiPicScanViewController.currentPhotoLibrarySelectedCount = currentPhotoLibrarySelectedCount;
    //转去浏览图片的界面
    [self.navigationController pushViewController:cameraMultiPicScanViewController animated:NO];
}

// 预览已被选中的图片
- (void)scanSelectedPictures{
    if( nil == cameraMultiPicScanViewController ){
        cameraMultiPicScanViewController = [[ESCameraMultiPicScanViewController alloc]init];
        //
        cameraMultiPicScanViewController.scanAndPickCommunicateDelegate = self;
    }
    //图片数量限制标记
    cameraMultiPicScanViewController.picMaxLimitMark = picMaxLimitMark;
    //图片数量最大值
    cameraMultiPicScanViewController.picMaxCount = picMaxCount;
    //标识浏览所有图片
    cameraMultiPicScanViewController.scanMark = NO;
    //传递照片数据
    cameraMultiPicScanViewController.photoUrlData = photoUrlData;
    //图片选择状态
    cameraMultiPicScanViewController.photoSelectState = photoSelectState;
    //
    //cameraMultiPicScanViewController.photoSelectData = photoSelectData;
    //已选择图片的数量
    cameraMultiPicScanViewController.currentPhotoLibrarySelectedCount = currentPhotoLibrarySelectedCount;
    //
    cameraMultiPicScanViewController.currentSelectedIndex = 0;
    //已选择图片的顺序(升序)
    //cameraMultiPicScanViewController.photoSelectIndexOrder = [self getSelectIndexOrderArray:[photoSelectData allKeys]];
    [self.navigationController pushViewController:cameraMultiPicScanViewController animated:NO];
}

// 取消并返回上一层
- (void)cancleAndBack{
    //还原选择状态
    for (NSString *key in photoSelectData) {
        if( NO == [photoSelectDataCache containsObject:key] ){
            ((UIImageView *)[photoSelectImgViewArray objectAtIndex:[key integerValue]]).image = selectedImg;
            [photoSelectState replaceObjectAtIndex:[key integerValue] withObject:[NSNumber numberWithInt:1]];
        }
    }
    //还原选择的缓存
    [photoSelectDataCache removeAllObjects];
    [photoSelectDataCache addObjectsFromArray:photoSelectData];
    //更新数量提醒
    currentPhotoLibrarySelectedCount = (int)[photoSelectData count];
    [self updateCurrentPhotoLibrarySelectedCountTip:currentPhotoLibrarySelectedCount];
    //关闭页面
    [self dismissViewControllerAnimated:YES completion:^{}];
}

// 完成数据传送并返回
- (void)finishAndBack{
    //清除已保存的图像信息
    NSArray *keyArray = [photoSelectImageData allKeys];
    for (NSString *key in keyArray) {
        if ( NO == [photoSelectDataCache containsObject:key] ) {
            [photoSelectImageData removeObjectForKey:key];
        }
    }
    //将选择的缓存保存起来
    [photoSelectData removeAllObjects];
    [photoSelectData addObjectsFromArray:photoSelectDataCache];
    //通过代理返回数据
    [self transferMultiPicturesData];
    //关闭当前页面
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 其他
// 获取已选择图片的顺序索引
- (NSArray *)getSelectIndexOrderArray:(NSArray *)array{
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *numStr1 = obj1, *numStr2 = obj2;
        NSInteger number1 = [numStr1 integerValue], number2 = [numStr2 integerValue];
        if (number1>=number2) {
            return YES;
        }else{
            return NO;
        }
    }];
}

// 根据图片索引, 及图片URL生成对应的图片并保存
- (void)saveImageByAlassetUrl:(NSURL *)url index:(NSInteger)index{
    [library assetForURL:url
             resultBlock:^(ALAsset *result){
                 [photoSelectImageData setObject:[UIImage imageWithCGImage:[[result defaultRepresentation]fullResolutionImage]]
                                          forKey:[NSString stringWithFormat:@"%ld", index]];
             }
            failureBlock:^(NSError *error){
            }
     ];
}

// 控件上删除图像之后的操作
- (void)deleteImageByIndex:(NSString *)index{
    //修改对应的状态, 调整为未选中
    [photoSelectState replaceObjectAtIndex:[index integerValue] withObject:[NSNumber numberWithInt:0]];
    //将图片对应的选中背景图改为不选中
    UIImageView *imageView = [photoSelectImgViewArray objectAtIndex:[index integerValue]];
    imageView.image = noSelectedImg;
    //删除对应的图像数据
    [photoSelectImageData removeObjectForKey:index];
    //从已选择中去除
    [photoSelectDataCache removeObject:index];
    [photoSelectData removeObject:index];
    //本地照片已选择的数量减1
    currentPhotoLibrarySelectedCount--;
    //更新已选择数量的显示
    [self updateCurrentPhotoLibrarySelectedCountTip:currentPhotoLibrarySelectedCount];
}

#pragma mark - 处理代理事件
// 处理图像的状态
- (void)managePictureState:(NSInteger)index selectedCount:(int)count{
    currentPhotoLibrarySelectedCount = count;
    NSNumber *number = [photoSelectState objectAtIndex:index];
    UIImageView *indexImageView = [photoSelectImgViewArray objectAtIndex:index];
    if ( 1 == [number integerValue] ) {//图片已被选中
        indexImageView.image = selectedImg ;
    }else{
        indexImageView.image = noSelectedImg ;
    }
    [self updateCurrentPhotoLibrarySelectedCountTip:currentPhotoLibrarySelectedCount];
}

// 将图像数据传输给控件
- (void)transferMultiPicturesData{
    if([self.multiPicDelegate respondsToSelector:@selector(transferMultiPic:)]){
        [self.multiPicDelegate transferMultiPic:photoSelectImageData];
    }
}

#pragma mark - 图片处理
// 获取本地相册的所有图片
- (void)getAllPhotoFromLibrary{
    //初始化
    photoData = [[NSMutableArray alloc]init];//
    photoUrlData = [[NSMutableArray alloc]init];//
    photoSelectImgViewArray = [[NSMutableArray alloc]init];//
    photoSelectState = [[NSMutableArray alloc]init];//
    photoSelectDataCache = [[NSMutableArray alloc]init];//
    photoSelectData = [[NSMutableArray alloc]init];//
    photoSelectImageData = [[NSMutableDictionary alloc]init];//
    
    //获取本地照片
    library = [[ALAssetsLibrary alloc] init];
    //遍历每个相册
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        //已遍历完全部照片
        if ( stop ) {
            //布置图片到视图中
            [self arrangImgInPhotoView];
        }
        //遍历相册的每张图片
        if (group != nil) {
            //设置照片过滤对象
            ALAssetsFilter *filter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:filter];
            //通过文件夹枚举遍历所有的相片ALAsset对象，有多少照片，则调用多少次block
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    //将result对象存储到数组中
                    [photoData addObject:result];
                    //保存每个asset的URL
                    [photoUrlData addObject:[[result defaultRepresentation] url]];
                }
            }];
        }
    } failureBlock:^(NSError *error) {
    }];
}

// 布置图片到图片视图
- (void)arrangImgInPhotoView{
    
    int currentRow=1, currentColumn=1;
    
    CGSize contentSize = pickPhotoView.contentSize;
    contentSize.height = verticalShift*([photoData count]/pickPhotoViewRowSize)+verticalShift*0.35;//加多verticalShift*0.3以便显示最底部的相片
    pickPhotoView.contentSize = contentSize;
    //获取到相片的缩略图
    for (ALAsset *data in photoData) {
        UIImage *image = [UIImage imageWithCGImage:[data thumbnail]];
        if (currentColumn>pickPhotoViewRowSize) {//
            currentRow = currentRow+1;
            currentColumn = 1;
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(photoStarPoint.x+horizonShift*(currentColumn-1), photoStarPoint.y+verticalShift*(currentRow-1), pickPhotoViewPerPicSize.width, pickPhotoViewPerPicSize.height)];
        imageView.image = image;
        [pickPhotoView addSubview:imageView];//照片小图
        
        CGRect selectOrNotFrame = CGRectMake(selectStarPoint.x+horizonShift*(currentColumn-1), selectStarPoint.y+verticalShift*(currentRow-1), selectSize.width, selectSize.height);
        UIImageView *selectOrNotView = [[UIImageView alloc]initWithFrame:selectOrNotFrame];
        selectOrNotView.image = noSelectedImg;
        [photoSelectImgViewArray addObject:selectOrNotView];//保存各个预览图对应的状态背景图
        NSNumber *state = [NSNumber numberWithInt:0];
        [photoSelectState addObject:state];//保存状态
        [pickPhotoView addSubview:selectOrNotView];//选中或不选中背景图
        
        UIButton *selectOrNotBtn = [[UIButton alloc]initWithFrame:selectOrNotFrame];
        selectOrNotBtn.tag = (currentRow-1)*pickPhotoViewRowSize+currentColumn-1;//数组是从0开始计算, 因此需要减1
        selectOrNotBtn.backgroundColor = [UIColor clearColor];
        [selectOrNotBtn addTarget:self action:@selector(selectOrNotEvent:) forControlEvents:UIControlEventTouchUpInside];
        [pickPhotoView addSubview:selectOrNotBtn];//选中或不选中按钮
        
        CGRect scanFrame = CGRectMake(scanStarPoint.x+horizonShift*(currentColumn-1), scanStarPoint.y+verticalShift*(currentRow-1), scanSize.width, scanSize.height);
        UIButton *scanBtn = [[UIButton alloc]initWithFrame:scanFrame];
        scanBtn.tag = (currentRow-1)*pickPhotoViewRowSize+currentColumn-1;//数组是从0开始计算, 因此需要减1
        scanBtn.backgroundColor = [UIColor clearColor];
        [scanBtn addTarget:self action:@selector(scanEvent:) forControlEvents:UIControlEventTouchUpInside];
        [pickPhotoView addSubview:scanBtn];//预览按钮
        
        currentColumn = currentColumn+1;//指向下一列
    }
    
    //获取照片之后的后序操作
}

#pragma mark - 样式处理
// 全局样式
- (void)customizedGlobalView{
    self.view.backgroundColor = [UIColor whiteColor];
}

// 预设值
- (void)customizedPresetValue{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];//获取窗口大小;
    //标准值设置
    standToolBarWidth = 750;//
    standToolBarHeight = 110;//
    pickPhotoViewColorHexValue = @"eaeaea";//
    pickPhotoViewRowSize = 4;//每行放置的图片数量
    standPickPhotoViewPerPicSize = CGSizeMake(163, 184);//
    standPickPhotoViewSpan = 18;//
    standPickPhotoViewHorizonSpace = 15;//
    standPickPhotoViewVerticalSpace = 15;//
    
    //大小计算
    toolBarSize = CGSizeMake(frame.size.width, frame.size.width*standToolBarHeight/standToolBarWidth);//
    //图片视图的大小
    pickPhotoViewSize = frame.size;
    pickPhotoViewSize.height = pickPhotoViewSize.height - toolBarSize.height - self.navigationController.navigationBar.bounds.size.height;
    //每张图的大小
    pickPhotoViewPerPicSize = CGSizeMake(frame.size.width*standPickPhotoViewPerPicSize.width/standToolBarWidth, frame.size.width*standPickPhotoViewPerPicSize.height/standToolBarWidth);
    //与边缘的间距
    pickPhotoViewSpan = frame.size.width*standPickPhotoViewSpan/standToolBarWidth;
    //相片水平间隔
    pickPhotoViewHorizonSpace = (frame.size.width-2*pickPhotoViewSpan-4*pickPhotoViewPerPicSize.width)/(pickPhotoViewRowSize-1);
    //相片垂直间隔
    pickPhotoViewVerticalSpace = frame.size.width*standPickPhotoViewVerticalSpace/standToolBarWidth;
    //水平位移
    horizonShift = pickPhotoViewHorizonSpace + pickPhotoViewPerPicSize.width;
    //垂直位移
    verticalShift = pickPhotoViewVerticalSpace + pickPhotoViewPerPicSize.height;
    //选择背景图的大小
    selectSize = CGSizeMake(pickPhotoViewPerPicSize.width/3, pickPhotoViewPerPicSize.width/3);
    //预览点击框的大小
    scanSize = CGSizeMake(pickPhotoViewPerPicSize.width*2/3, pickPhotoViewPerPicSize.width*2/3);
    //预览按钮的大小
    scanButtonSize = CGSizeMake(toolBarSize.width/4, toolBarSize.height);
    //完成按钮的大小
    finishButtonSize = CGSizeMake(toolBarSize.width/7, toolBarSize.height);
    //
    currentSelectedCountLabelSize = CGSizeMake(toolBarSize.width-scanButtonSize.width-finishButtonSize.width-2*pickPhotoViewSpan, toolBarSize.height);
    //工具栏按钮的字体大小
    toolbarButtonFontSize = toolBarSize.height*0.37;
    
    //位置计算
    pickPhotoViewPoint = CGPointMake(0, 0);
    toolBarPoint = CGPointMake(0, pickPhotoViewSize.height);
    //
    photoStarPoint = CGPointMake(pickPhotoViewSpan, pickPhotoViewVerticalSpace);
    //
    selectStarPoint = CGPointMake(photoStarPoint.x+pickPhotoViewPerPicSize.width*2/3, photoStarPoint.y);
    //
    scanStarPoint = CGPointMake(photoStarPoint.x, photoStarPoint.y+pickPhotoViewPerPicSize.width/3);
    //预览按钮的位置
    scanButtonPoint = CGPointMake(pickPhotoViewSpan, 0);
    //完成按钮的位置
    finishButtonPoint = CGPointMake(toolBarSize.width-pickPhotoViewSpan-finishButtonSize.width, 0);
    //
    currentSelectedCountLabelPoint = CGPointMake(pickPhotoViewSpan+scanButtonSize.width, 0);
    
    //图片
    //选中
    selectedImg = [UIImage imageNamed:@"selected@3x.png"];
    //未选中
    noSelectedImg = [UIImage imageNamed:@"noSelected@3x.png"];
    //返回按钮
    backButtonImg = [UIImage imageNamed:@"backBtn@3x.png"];
}

// 导航条样式
- (void)customizedNavigationBar{
    //不隐藏导航栏
    self.navigationController.navigationBar.hidden = NO;
    //设置navigationbar上显示的标题
    self.title = @"选择照片";
    //设置navigationbar的颜色
    //[self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];
    //
    self.navigationController.navigationBar.translucent = NO;
    //导航栏左边返回按钮
    //UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithImage:backButtonImg style:UIBarButtonItemStylePlain target:self action:@selector(cancleAndBack)];
    //导航栏右边取消按钮
    rightCancleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleAndBack)];
    //self.navigationItem.leftBarButtonItem = leftBackItem;
    self.navigationItem.rightBarButtonItem = rightCancleItem;
}

// 图片多选视图
- (void)customizedPickPhotoView{
    CGRect pickPhotoViewFrame = CGRectMake(pickPhotoViewPoint.x, pickPhotoViewPoint.y, pickPhotoViewSize.width, pickPhotoViewSize.height);
    pickPhotoView = [[UIScrollView alloc] initWithFrame:pickPhotoViewFrame];
    pickPhotoView.backgroundColor = [ESColorUtil getColorFromHexValue:pickPhotoViewColorHexValue];
    [self.view addSubview:pickPhotoView];
}

// 工具栏样式
- (void)customizedToolBar{
    CGRect stateBarFrame = CGRectMake(toolBarPoint.x, toolBarPoint.y, toolBarSize.width, toolBarSize.height);
    toolBarView = [[UIView alloc]initWithFrame:stateBarFrame];
    toolBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolBarView];
    //工具条上的预览按钮
    scanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    scanButton.frame = CGRectMake(scanButtonPoint.x, scanButtonPoint.y, scanButtonSize.width, scanButtonSize.height);
    [scanButton setTitle:@"预览" forState:UIControlStateNormal];
    scanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    scanButton.titleLabel.font = [UIFont systemFontOfSize:toolbarButtonFontSize];
    [scanButton addTarget:self action:@selector(scanSelectedPictures) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:scanButton];
    
    //工具条上的完成按钮
    finishButton = [UIButton buttonWithType:UIButtonTypeSystem];
    finishButton.frame = CGRectMake(finishButtonPoint.x, finishButtonPoint.y, finishButtonSize.width, finishButtonSize.height);
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    finishButton.titleLabel.font = [UIFont systemFontOfSize:toolbarButtonFontSize];
    [finishButton addTarget:self action:@selector(finishAndBack) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:finishButton];
    
    //工具条上的多少张图片
    currentSelectedCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(currentSelectedCountLabelPoint.x, currentSelectedCountLabelPoint.y, currentSelectedCountLabelSize.width, currentSelectedCountLabelSize.height)];
    currentSelectedCountLabel.textAlignment = NSTextAlignmentRight;
    currentSelectedCountLabel.font = [UIFont systemFontOfSize:toolbarButtonFontSize];
    currentSelectedCountLabel.textColor = finishButton.tintColor;
    [self updateCurrentPhotoLibrarySelectedCountTip:currentPhotoLibrarySelectedCount];
    [toolBarView addSubview:currentSelectedCountLabel];
    
}

// 更新已选择的图片数量提示
- (void)updateCurrentPhotoLibrarySelectedCountTip:(int)count{
    if( 0 == count ){
        currentSelectedCountLabel.text = @"";
        scanButton.enabled = NO;
        finishButton.enabled = NO;
    }else{
        currentSelectedCountLabel.text = [NSString stringWithFormat:@"%d", currentPhotoLibrarySelectedCount];
        scanButton.enabled = YES;
        finishButton.enabled = YES;
    }
}

@end