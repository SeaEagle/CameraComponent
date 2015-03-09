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
        //
        snapshootFeedback = [[ESSnapshootFeedback alloc]init];
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

// 相机控件初始化
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

#pragma mark - 代理方法处理
// 获取已选择的主题
- (void)handleThemeOperation:(ESSnapshootTheme *)theme{
    // 已选择的主题
    snapshootFeedback.theme = theme;
    // 更新主题显示
    _snapshootThemeField.text = theme.displayThemeName;
}

#pragma mark - 跳转处理
// 跳转之前的准备
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SnapshootTheme"]){//拍照主题
        
        snapshootThemeViewController = segue.destinationViewController;
        snapshootThemeViewController.themeDelegate = self;
        
    }else if([segue.identifier isEqualToString:@"SnapshootRecords"]){//拍照记录
        
    }
}

#pragma mark - 键盘处理
// 显示键盘
- (IBAction)editBegin:(id)sender {
    //创建一个仿射变换，平移(0, -100)视图上移100像素
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, -100);
    //使视图使用这个变换
    self.containerView.transform = pTransform;
}

// 隐藏键盘
- (IBAction)editEnd:(id)sender {
    [sender resignFirstResponder];
    //创建一个仿射变换，平移(0, -100)视图上移100像素
    CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, 0);
    //使视图使用这个变换
    self.containerView.transform = pTransform;
}

#pragma mark - 照片反馈数据上传
// 上传拍照反馈表单数据
- (IBAction)uploadSnapshootFeedbackData:(id)sender {
    // 获取相关的参数
    
    // 获取拍照控件的图片数据
    snapshootFeedback.imageData = [cameraComponent getImageData];
    // 拍照反馈描述
    snapshootFeedback.remark = _snapshootRemarkField.text;
    // 拍照反馈坐标数据
    
    // 通过接口提交数据
    if ( nil == networkClient ) {
        networkClient = [[ESNetworkClient alloc]initManager];
    }
    // 设置参数 - (此处参数需要动态获得)
    NSDictionary *token = [[NSDictionary alloc]initWithObjectsAndKeys:@"1000100", @"x-action-type", @"111", @"x-session-id", nil];
    NSDictionary *paramer = snapshootFeedback.getParameterDictionary;
    
    // 提交数据
    [networkClient
     getJson:token
     params:paramer
     onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
         // 解析接口返回数据
         NSString *resultContent = [JSON objectForKey:@"result"];
         NSData *resultData = [resultContent dataUsingEncoding:NSUTF8StringEncoding];
         NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
         NSLog(@"%@", resultArray);
         // 上传文件
         [self uploadSnapshootFeedbackImageData:snapshootFeedback.imageData withTicket:resultArray];
     }onError:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
         //
         NSLog(@"Error: %@", error.description);
     }];
}

// 上传拍照反馈使用的图片数据
- (void)uploadSnapshootFeedbackImageData:(NSArray *)imageData withTicket:(NSArray *)ticketArray{
    for(NSInteger index=0; index<[ticketArray count]; index++){
        // 设置参数 - (此处参数需要动态设置)
        NSDictionary *token = [[NSDictionary alloc]initWithObjectsAndKeys:
                               @"2019900", @"x-action-type",
                               @"111", @"x-session-id",
                               @"jpg", @"x-type",
                               [ticketArray objectAtIndex:index], @"x-ticket",
                               nil];
        // 设置对应的图片
        NSDictionary *paramer = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 (UIImage *)[imageData objectAtIndex:index],@"image",
                                 nil];
        ESNetworkClient *fileNetworkClient = [[ESNetworkClient alloc]init];
        [fileNetworkClient
         uploadFile:token
         params:paramer
         onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
             // 图片上传回调
         } onError:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
             //
             NSLog(@"Error: %@", error.description);
         }];
    }
}

// 图片上传回调接口
- (void)uploadImageDataFeedback{
}

@end
