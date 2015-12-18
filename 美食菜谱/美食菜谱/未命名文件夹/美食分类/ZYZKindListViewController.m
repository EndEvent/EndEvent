//
//  ZYZKindListViewController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/17.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZKindListViewController.h"
#import "ZYZKindListCell.h"

@interface ZYZKindListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;
@end

@implementation ZYZKindListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNac];
    
    [self createTableView];
    
    [self addRefresh];
    
    // 开始下拉刷新
    [_tableView headerBeginRefreshing];
}

#pragma mark - 获取数据
- (void)loadData{
    __weak typeof(self) weakSelf = self;
    _keyWord = [_keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"http://ibaby.ipadown.com/api/food/food.show.list.php?category=%@&&p=%@&pagesize=%@",_keyWord,[NSString stringWithFormat:@"%ld",(long)_page],@"12"];
    
    ZYZHttpRequestBlock *request = [[ZYZHttpRequestBlock alloc] initHttpRequestWithUrlStr:urlStr httpBlcok:^(BOOL isSucceed, ZYZHttpRequestBlock *request) {
        if (isSucceed) {
            if (weakSelf.page == 1) {
                weakSelf.dataArray = [NSMutableArray array];
            }
            
            // 转模型
            NSArray *array = request.dataDict[@"results"];
            for (NSDictionary *dic in array) {
                ZYZKindModel *model = [[ZYZKindModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
            
            // 刷新表格
            [weakSelf.tableView reloadData];
            
            // 关闭上/下拉刷新
            if (weakSelf.page == 1) {
                [weakSelf.tableView headerEndRefreshing];
            }else{
                [weakSelf.tableView footerEndRefreshing];
            }
        }else{
            NSLog(@"获取数据失败");
        }
    }];
}

#pragma mark - 上下拉刷新
- (void)addRefresh{
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    [_tableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf loadData];
    } dateKey:@"ZYZKindListCell"];
    [_tableView setHeaderPullToRefreshText:@"下拉刷新数据"];
    [_tableView setHeaderRefreshingText:@"正在努力加载..."];
    [_tableView setHeaderReleaseToRefreshText:@"松手开始加载数据"];
    
    
    // 上拉加载
    [_tableView addFooterWithCallback:^{
        weakSelf.page ++;
        [weakSelf loadData];
    }];
    [_tableView setFooterPullToRefreshText:@"上拉刷新数据"];
    [_tableView setFooterRefreshingText:@"正在努力加载..."];
    [_tableView setFooterReleaseToRefreshText:@"松手开始加载数据"];
}

#pragma mark - 表格视图代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ZYZKindListCell";
    ZYZKindListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZYZKindListCell" owner:self options:nil] firstObject];
    }
    

    [cell setCellWithModel:_dataArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZYZKindModel *model = _dataArray[indexPath.row];
    
    ZYZDetailWebViewController *detailVC = [[ZYZDetailWebViewController alloc] init];
    detailVC.urlid = model.ID;
    detailVC.shareTitle = model.title;
    detailVC.contentsString = model.yingyang;
    detailVC.photoUrlString = model.thumb_2;
    detailVC.yuanLiao = model.yuanliao;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 表格视图
- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 导航栏设置
- (void)setNac{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setImage:[UIImage imageNamed:@"icon6-1.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

// 返回
- (void)leftbuttonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
