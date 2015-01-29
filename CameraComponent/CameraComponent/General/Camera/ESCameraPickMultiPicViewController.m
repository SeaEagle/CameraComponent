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
@synthesize currentSelectedCount;//当前已选择数量

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
        if (picMaxLimitMark && picMaxCount <= currentSelectedCount ) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"提示"
                                       message:[NSString stringWithFormat:@"最多只能选择%d图片", picMaxCount]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
            [alert show];
        }else{
            selectOrNotView.image = selectedImg;
            state = [NSNumber numberWithInt:1];
            currentSelectedCount++;
        }
    }else{//选中变为不选中
        selectOrNotView.image = noSelectedImg;
        state = [NSNumber numberWithInt:0];
        currentSelectedCount--;
    }
    [photoSelectState replaceObjectAtIndex:button.tag withObject:state];
}

// 点击图片弹出的预览事件 -- 预览所有图片
- (void)scanEvent:(UIButton *)button{
    if( nil == cameraMultiPicScanViewController ){
        cameraMultiPicScanViewController = [[ESCameraMultiPicScanViewController alloc]init];
        //图片数量限制标记
        cameraMultiPicScanViewController.picMaxLimitMark = picMaxLimitMark;
        //图片数量最大值
        cameraMultiPicScanViewController.picMaxCount = picMaxCount;
        //
        cameraMultiPicScanViewController.scanAndPickCommunicateDelegate = self;
    }
    //标识浏览所有图片
    cameraMultiPicScanViewController.scanMark = YES;
    //传递照片数据
    cameraMultiPicScanViewController.photoUrlData = photoUrlData;
    //设置索引,从索引处开始浏览图片
    cameraMultiPicScanViewController.currentIndex = button.tag;
    //图片选择状态
    cameraMultiPicScanViewController.photoSelectState = photoSelectState;
    //已选择图片的数量
    cameraMultiPicScanViewController.currentSelectedCount = currentSelectedCount;
    //转去浏览图片的界面
    [self.navigationController pushViewController:cameraMultiPicScanViewController animated:NO];
}

// 预览已被选中的图片
- (void)scanSelectedPictures{
    if( nil == cameraMultiPicScanViewController ){
        cameraMultiPicScanViewController = [[ESCameraMultiPicScanViewController alloc]init];
    }
    [self.navigationController pushViewController:cameraMultiPicScanViewController animated:NO];
}

// 取消并返回上一层
- (void)cancleAndBack{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 处理代理事件
- (void) managePictureState:(NSInteger)index selectedCount:(int)count{
    currentSelectedCount = count;
    NSNumber *number = [photoSelectState objectAtIndex:index];
    UIImageView *indexImageView = [photoSelectImgViewArray objectAtIndex:index];
    if ( 1 == [number integerValue] ) {//图片已被选中
        indexImageView.image = selectedImg ;
    }else{
        indexImageView.image = noSelectedImg ;
    }
}

#pragma mark - 图片处理
// 获取本地相册的所有图片
- (void)getAllPhotoFromLibrary{
    photoData = [[NSMutableArray alloc]init];
    photoUrlData = [[NSMutableArray alloc]init];
    photoSelectImgViewArray = [[NSMutableArray alloc]init];
    photoSelectState = [[NSMutableArray alloc]init];
    //获取本地照片
    ALAssetsLibrary *libray = [[ALAssetsLibrary alloc] init];
    //遍历每个相册
    [libray enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop){
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
    contentSize.height = verticalShift*([photoData count]/pickPhotoViewRowSize)+verticalShift*0.3;//加多verticalShift*0.3以便显示最底部的相片
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
        [photoSelectImgViewArray addObject:selectOrNotView];
        NSNumber *state = [NSNumber numberWithInt:0];
        [photoSelectState addObject:state];
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
    
    //位置计算
    pickPhotoViewPoint = CGPointMake(0, 0);
    toolBarPoint = CGPointMake(0, pickPhotoViewSize.height);
    //
    photoStarPoint = CGPointMake(pickPhotoViewSpan, pickPhotoViewVerticalSpace);
    //
    selectStarPoint = CGPointMake(photoStarPoint.x+pickPhotoViewPerPicSize.width*2/3, photoStarPoint.y);
    //
    scanStarPoint = CGPointMake(photoStarPoint.x, photoStarPoint.y+pickPhotoViewPerPicSize.width/3);
    
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
    UIBarButtonItem *rightCancleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleAndBack)];
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
}

- (void)test{
    if([self.multiPicDelegate respondsToSelector:@selector(multiPicDelegate)]){
        [self.multiPicDelegate manageMultiPic];
    }
}

@end