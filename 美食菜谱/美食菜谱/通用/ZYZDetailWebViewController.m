//
//  ZYZDetailWebViewController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/15.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZDetailWebViewController.h"
#import "ZYZCollectModel.h"

@interface ZYZDetailWebViewController () <UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *myWebView;

@end

@implementation ZYZDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航栏设置
    [self setNac];
    
    // 创建web
    [self createWeb];
}


#pragma mark - 创建web
- (void)createWeb{
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    
    _myWebView.delegate = self;
    
    _myWebView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_myWebView];
    
    NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"http://ibaby.ipadown.com/api/food/food.show.detail.php?id=%@",self.urlid]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlString];
    
    [_myWebView loadRequest:request];
    
    [_myWebView reload];
}

#pragma mark 网页加载完成后移除HUD
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

#pragma mark 网页加载失败时调用,这里点击那个网页收藏按钮也会调用来这里，所以做了一个提示框
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如您要收藏，请点击右上角收藏按钮哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"嗯嗯!", nil];
    
    [alerView show];
}

#pragma mark - 导航栏设置
- (void)setNac{
    self.title = @"详细做法";
    
    
    // 分享按钮
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 40, 40);
    [rightbutton setImage:[UIImage imageNamed:@"sharebutton.png"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.frame = CGRectMake(0, 0, 40, 40);
    [collectionButton setImage:[UIImage imageNamed:@"icon7"] forState:UIControlStateNormal];
    collectionButton.tintColor = [UIColor whiteColor];
    [collectionButton addTarget:self action:@selector(collectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:collectionButton];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setImage:[UIImage imageNamed:@"icon6-1.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

#pragma mark 返回
- (void)leftbuttonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 收藏
- (void)collectionButtonClick{
//    NSLog(@"收藏操作");
    
    ZYZDBManager *dbManager = [ZYZDBManager shareDBManager];
    
    // 要收藏的数据
    ZYZCollectModel *model = [[ZYZCollectModel alloc] init];
    model.thumb_2 = _photoUrlString;
    model.title = _shareTitle;
    model.yingyang = _contentsString;
    model.ID = _urlid;
    
    
    // 检索数据库，看是否有收藏
    // 默认是没有收藏
    BOOL isCollect = NO;
    NSArray *selectArray = [dbManager selectDbWithTableName:@"ZYZCollectModel"];
    for (ZYZCollectModel *collectModel in selectArray) {
        if ([collectModel.ID isEqualToString:model.ID]) {
            // 如果已经收藏，弹出已收藏提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该美食您已收藏过了，无需再次收藏哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            // 已经收藏
            isCollect = YES;
        }
    }
    
    // 进行收藏操作
    if (!isCollect) {
        [dbManager insertDbWithModel:model];
        
        // 弹出收藏成功提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"美食已收藏成功，请在我的收藏查看哦" delegate:self cancelButtonTitle:@"嗯嗯，知道了！" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark 分享
- (void)rightButtonClick{
    NSLog(@"分享");
}

@end
