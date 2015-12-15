//
//  ZYZRecommendViewController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZRecommendViewController.h"
#import "ZYZRecommendCell.h"

@interface ZYZRecommendViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;

@end

@implementation ZYZRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建表格视图
    [self createTableView];
    
    // 上下拉刷新
    [self createRefresh];
    
    // 加载数据
//    [self loadData];
    // 开始下拉加载数据
    _page = 0;
    [_tableView headerBeginRefreshing];
}

#pragma mark - 加载数据
- (void)loadData{
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"http://ibaby.ipadown.com/api/food/food.show.list.php?search=%@&p=%@&pagesize=%@",@"",[NSString stringWithFormat:@"%d",_page],@"12"];
    ZYZHttpRequestBlock *request = [[ZYZHttpRequestBlock alloc] initHttpRequestWithUrlStr:urlStr httpBlcok:^(BOOL isSucceed, ZYZHttpRequestBlock *request) {
        if (isSucceed) {
//            NSLog(@"%@",request.dataDict);
            
            if (weakSelf.page == 1) {
                weakSelf.dataArray = [NSMutableArray array];
            }
            
            // 字典转模型
//            _dataArray = [ZYZRecommendModel recommendModelWithDict:request.dataDict];
            
            NSArray *array = request.dataDict[@"results"];
            for (NSDictionary *dic in array) {
                ZYZRecommendModel *model = [[ZYZRecommendModel alloc] init];
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
- (void)createRefresh{
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    [_tableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        [weakSelf loadData];
    } dateKey:@"tableView"];
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

#pragma mark - 创建表格视图
- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 表格视图代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ZYZRecommendCell";
    ZYZRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
//        cell = [[ZYZRecommendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZYZRecommendCell" owner:self options:nil] firstObject];
    }
    
    [cell setCellWithModel:_dataArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
//    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZYZRecommendModel *model = _dataArray[indexPath.row];
    
    ZYZDetailWebViewController *detailVC = [[ZYZDetailWebViewController alloc] init];
    detailVC.urlid = model.ID;
    detailVC.shareTitle = model.title;
    detailVC.contentsString = model.yingyang;
    detailVC.photoUrlString = model.thumb_2;
    detailVC.yuanLiao = model.yuanliao;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    // 反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
