//
//  ESSnapshootThemeTableViewController.m
//  CameraComponent
//
//  Created by SeaEagle on 15/2/10.
//  Copyright (c) 2015年 Eshore. All rights reserved.
//

#import "ESSnapshootThemeTableViewController.h"

@interface ESSnapshootThemeTableViewController ()

@end

@implementation ESSnapshootThemeTableViewController

//
@synthesize snapshootThemeData;
//
@synthesize themeDelegate;

#pragma mark - 初始化
// 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化拍照主题数据
    [self initSnapshootThemeData];
    
    // 清除多余的分割线
    [self clearExtraSperateLine];
    
    // 初始化子主题tableview
    [self customizedSubThemeView];
    
    // 清除选项
    // self.clearsSelectionOnViewWillAppear = NO;
    // 编辑
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 初始化拍照主题数据
- (void)initSnapshootThemeData{
    // 通过接口获取拍照主题数据
    ESNetworkClient *networkClient = [[ESNetworkClient alloc]initManager];
    // 设置参数
    NSDictionary *token = [[NSDictionary alloc]initWithObjectsAndKeys:@"1010100", @"x-action-type", @"111", @"x-session-id", nil];
    NSDictionary *paramer = [[NSDictionary alloc]init];
    // 请求数据
    [networkClient
     getJson:token
     params:paramer
     onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
         // 解析接口返回数据
         NSString *resultContent = [JSON objectForKey:@"result"];
         NSData *resultData = [resultContent dataUsingEncoding:NSUTF8StringEncoding];
         NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
         // 初始化主题数据
         snapshootThemeData = [ESSnapshootTheme initSnapshootThemeData:resultArray];
         //刷新数据
         [self.tableView reloadData];
     }onError:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
         
     }];
    //测试数据
//    snapshootThemeData = [[NSMutableArray alloc]init];
//    ESSnapshootTheme *theme1 = [[ESSnapshootTheme alloc]init];
//    theme1.themeId = @"1";
//    theme1.themeName = @"theme1";
//    [snapshootThemeData addObject:theme1];
//    theme1.subThemes = [[NSMutableArray alloc]init];
//    ESSnapshootTheme *subtheme11 = [[ESSnapshootTheme alloc]init];
//    subtheme11.themeId = @"11";
//    subtheme11.themeName = @"subtheme11";
//    [theme1.subThemes addObject:subtheme11];
//    ESSnapshootTheme *subtheme12 = [[ESSnapshootTheme alloc]init];
//    subtheme12.themeId = @"12";
//    subtheme12.themeName = @"subtheme12";
//    [theme1.subThemes addObject:subtheme12];
//    ESSnapshootTheme *theme2 = [[ESSnapshootTheme alloc]init];
//    theme2.themeId = @"2";
//    theme2.themeName = @"theme2";
//    [snapshootThemeData addObject:theme2];
//    ESSnapshootTheme *theme3 = [[ESSnapshootTheme alloc]init];
//    theme3.themeId = @"3";
//    theme3.themeName = @"theme3";
//    [snapshootThemeData addObject:theme3];
//    theme3.subThemes = [[NSMutableArray alloc]init];
//    ESSnapshootTheme *subtheme31 = [[ESSnapshootTheme alloc]init];
//    subtheme31.themeId = @"31";
//    subtheme31.themeName = @"subtheme31";
//    [theme3.subThemes addObject:subtheme31];
//    ESSnapshootTheme *subtheme32 = [[ESSnapshootTheme alloc]init];
//    subtheme32.themeId = @"32";
//    subtheme32.themeName = @"subtheme32";
//    [theme3.subThemes addObject:subtheme32];
}

// 清空多余的分割线
- (void)clearExtraSperateLine{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

// 初始化子主题tableview
- (void)customizedSubThemeView{
    showSubThemeMark = NO;
    CGRect frame = self.tableView.frame;
    frame.origin.x = frame.origin.x + frame.size.width;
    frame.size.width = frame.size.width * 0.6;
    subThemeView = [[ESSnapshootSubThemeTableView alloc]initWithFrame:frame];
    subThemeView.subThemeDelegate = self;
    [self.view addSubview:subThemeView];
}

#pragma mark - 导航跳转前处理
// 跳转之前的准备
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}

#pragma mark - 
// 确定选择了某个主题
- (void)submitTheTheme:(ESSnapshootTheme *)theme{
    // 通过代理通知选择了哪个主题
    if( [self.themeDelegate respondsToSelector:@selector(handleThemeOperation:)] ){
        [self.themeDelegate handleThemeOperation:theme];
    }
    // 返回rootviewcontroller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 代理方法
- (void)handleSubThemeOperation:(ESSnapshootTheme *)subTheme{
    // 通过代理从子主题tableview获取数据
    [self submitTheTheme:subTheme];
    // 隐藏子主题tableview
    if ( YES == showSubThemeMark ) {
        [self hideSubThemeView];
        showSubThemeMark = NO;
    }
}

#pragma mark - Table view data source
// 表的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [snapshootThemeData count];
}

// 表的每一列
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THEMECELLIDENTIFIER];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THEMECELLIDENTIFIER];
    }
    ESSnapshootTheme *theme = [snapshootThemeData objectAtIndex:indexPath.row];
    cell.textLabel.text = theme.themeName;
    return cell;
}

// 设置每一列的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

// 选择某列之后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ESSnapshootTheme *theme = [snapshootThemeData objectAtIndex:indexPath.row];
    subThemeView.themeData = theme.subThemes;//
    if ( 0 == [theme.subThemes count]) {// 没有子主题
        if ( YES == showSubThemeMark ) {// 已经打开子主题显示view
            [self hideSubThemeView];// 关闭子主题显示view
            showSubThemeMark = NO;
        }
        // 通知选择了没有子主题的顶层主题
        [self submitTheTheme:theme];
    }else{// 存在子主题
        if( NO == showSubThemeMark ){// 没打开子主题显示view
            [self showSubThemeView];// 显示子主题view
            showSubThemeMark = YES;
        }
    }
    [subThemeView reloadData];// 刷新子主题view数据显示
    // 取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 子主题页面
// 隐藏子主题页面
- (void)hideSubThemeView{
    CGRect subThemeFrame = subThemeView.frame;
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//动画的方式
    [UIView setAnimationDuration:0.3];//动画时间
    subThemeFrame.origin.x = subThemeFrame.origin.x + subThemeFrame.size.width;//
    subThemeView.frame = subThemeFrame;//
    [UIView commitAnimations];//动画提交
}

// 显示子主题页面
- (void)showSubThemeView{
    CGRect subThemeFrame = subThemeView.frame;
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//动画的方式
    [UIView setAnimationDuration:0.3];//动画时间
    subThemeFrame.origin.x = subThemeFrame.origin.x - subThemeFrame.size.width;//
    subThemeView.frame = subThemeFrame;//
    [UIView commitAnimations];//动画提交
}

@end