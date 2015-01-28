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

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self customizedInitView];
    //设定初始值
    [self customizedPresetValue];
    //
    [self customizedNavigationBar];
    //图片多选视图
    [self customizedPickPhotoView];
    //状态栏
    [self customizedStateBar];
    //获取本地图片
    [self getAllPhotoFromLibrary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮的事件处理
// 选择或取消选择
- (void)selectOrNotEvent:(UIButton *)button{
    NSNumber *state = [photoSelectState objectAtIndex:(button.tag-1)];
    UIImageView *selectOrNotView = [photoSelectImgViewArray objectAtIndex:(button.tag-1)];//数组是从0开始计算, 因此需要减1
    if ( 0 == [state intValue] ) {//不选中变为选中
        selectOrNotView.image = selectedImg;
        state = [NSNumber numberWithInt:1];
    }else{//选中变为不选中
        selectOrNotView.image = noSelectedImg;
        state = [NSNumber numberWithInt:0];
    }
    [photoSelectState replaceObjectAtIndex:(button.tag-1) withObject:state];
}

// 预览事件
- (void)scanEvent:(UIButton *)button{
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"提示"
                               message:@"准备预览"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
    [alert show];
}

// 取消并返回上一层
- (void)cancleAndBack{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 图片
// 获取本地相册的所有图片
- (void)getAllPhotoFromLibrary{
    photoData = [[NSMutableArray alloc]init];
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
        selectOrNotBtn.tag = (currentRow-1)*pickPhotoViewRowSize+currentColumn;
        selectOrNotBtn.backgroundColor = [UIColor clearColor];
        [selectOrNotBtn addTarget:self action:@selector(selectOrNotEvent:) forControlEvents:UIControlEventTouchUpInside];
        [pickPhotoView addSubview:selectOrNotBtn];//选中或不选中按钮
        
        CGRect scanFrame = CGRectMake(scanStarPoint.x+horizonShift*(currentColumn-1), scanStarPoint.y+verticalShift*(currentRow-1), scanSize.width, scanSize.height);
        UIButton *scanBtn = [[UIButton alloc]initWithFrame:scanFrame];
        scanBtn.tag = (currentRow-1)*pickPhotoViewRowSize+currentColumn;
        scanBtn.backgroundColor = [UIColor clearColor];
        [scanBtn addTarget:self action:@selector(scanEvent:) forControlEvents:UIControlEventTouchUpInside];
        [pickPhotoView addSubview:scanBtn];//预览按钮
        
        currentColumn = currentColumn+1;//指向下一列
    }
    
    //获取照片之后的后序操作
}

- (void)getrawPic{
    //                获取原图
    //                UIImage *fullImage = [UIImage imageWithCGImage:[data.defaultRepresentation fullScreenImage]
    //                                                         scale:[data.defaultRepresentation scale]
    //                                                   orientation:(UIImageOrientation)[data.defaultRepresentation orientation]];
}

#pragma mark - 样式处理
//
- (void)customizedInitView{
    self.view.backgroundColor = [UIColor clearColor];
}

// 预设值
- (void)customizedPresetValue{
    CGRect frame = [[UIScreen mainScreen] bounds];//获取窗口大小;
    //标准值设置
    standStateBarWidth = 750;//
    standStateBarHeight = 110;//
    pickPhotoViewColorHexValue = @"eaeaea";//
    pickPhotoViewRowSize = 4;//每行放置的图片数量
    standPickPhotoViewPerPicSize = CGSizeMake(163, 184);//
    standPickPhotoViewSpan = 20;//
    standPickPhotoViewHorizonSpace = 15;//
    standPickPhotoViewVerticalSpace = 14;//
    
    //大小计算
    stateBarSize = CGSizeMake(frame.size.width, frame.size.width*standStateBarHeight/standStateBarWidth);//
    //图片视图的大小
    pickPhotoViewSize = frame.size;
    pickPhotoViewSize.height = pickPhotoViewSize.height - stateBarSize.height;
    //每张图的大小
    pickPhotoViewPerPicSize = CGSizeMake(frame.size.width*standPickPhotoViewPerPicSize.width/standStateBarWidth, frame.size.width*standPickPhotoViewPerPicSize.height/standStateBarWidth);
    //与边缘的间距
    pickPhotoViewSpan = frame.size.width*standPickPhotoViewSpan/standStateBarWidth;
    //相片水平间隔
    pickPhotoViewHorizonSpace = (frame.size.width-2*pickPhotoViewSpan-4*pickPhotoViewPerPicSize.width)/(pickPhotoViewRowSize-1);
    //相片垂直间隔
    pickPhotoViewVerticalSpace = frame.size.width*standPickPhotoViewVerticalSpace/standStateBarWidth;
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
    stateBarPoint = CGPointMake(0, pickPhotoViewSize.height);
    //
    photoStarPoint = CGPointMake(pickPhotoViewSpan, pickPhotoViewVerticalSpace);
    //
    selectStarPoint = CGPointMake(photoStarPoint.x+pickPhotoViewPerPicSize.width*2/3, photoStarPoint.y);
    //
    scanStarPoint = CGPointMake(photoStarPoint.x, photoStarPoint.y+pickPhotoViewPerPicSize.width/3);
    
    //
    selectedImg = [UIImage imageNamed:@"selected@3x.png"];
    noSelectedImg = [UIImage imageNamed:@"noSelected@3x.png"];
}

// 导航条样式
- (void)customizedNavigationBar{
    //不隐藏导航栏
    self.navigationController.navigationBar.hidden = NO;
    //设置navigationbar上显示的标题
    self.title = @"选择照片";
    //设置navigationbar的颜色
    //[self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];
    //导航栏左边返回按钮
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(cancleAndBack)];
    //导航栏右边取消按钮
    UIBarButtonItem *rightCancleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleAndBack)];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    self.navigationItem.rightBarButtonItem = rightCancleItem;
}

// 图片多选视图
- (void)customizedPickPhotoView{
    CGRect pickPhotoViewFrame = CGRectMake(pickPhotoViewPoint.x, pickPhotoViewPoint.y, pickPhotoViewSize.width, pickPhotoViewSize.height);
    pickPhotoView = [[UIScrollView alloc] initWithFrame:pickPhotoViewFrame];
    pickPhotoView.backgroundColor = [ESColorUtil getColorFromHexValue:pickPhotoViewColorHexValue];
    [self.view addSubview:pickPhotoView];
}

// 状态栏样式
- (void)customizedStateBar{
    CGRect stateBarFrame = CGRectMake(stateBarPoint.x, stateBarPoint.y, stateBarSize.width, stateBarSize.height);
    stateBarView = [[UIView alloc]initWithFrame:stateBarFrame];
    stateBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stateBarView];
}

- (void)test{
    if([self.multiPicDelegate respondsToSelector:@selector(multiPicDelegate)]){
        [self.multiPicDelegate manageMultiPic];
    }
}

@end
