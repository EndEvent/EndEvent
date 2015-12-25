//
//  ZYZTopViewController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZTopViewController.h"
#import "ZYZTopTableViewCell.h"
#import "ZYZTopDetailViewController.h"

@interface ZYZTopViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;
@end

@implementation ZYZTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self readyInit];
    
    [self createTableView];
    
    [self addRefresh];
    
    // 加载数据
    [self loadData];
}
#pragma mark - 加载数据
- (void)loadData{
    __weak typeof(self) weakSelf = self;
    [ZYZHttpRequestBlock httpRequestWithUlrStr:[NSString stringWithFormat:@"http://ibaby.ipadown.com/api/food/food.topic.list.php?p=%d&pagesize=12&order=addtime",_page] httpBlcok:^(BOOL isSucceed, ZYZHttpRequestBlock *request) {
        if (isSucceed) {
            NSLog(@"美食专题获取数据成功");
            
            if (weakSelf.page == 1) {
                weakSelf.dataArray = [NSMutableArray array];
            }
            
            NSArray *array = request.dataDict[@"results"];
            for (NSDictionary *dict in array) {
                ZYZTopModel *model = [[ZYZTopModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [weakSelf.dataArray addObject:model];
            }
            
            [weakSelf.tableView reloadData];
            
            if (weakSelf.page == 1) {
                [weakSelf.tableView headerEndRefreshing];
            }else{
                [weakSelf.tableView footerEndRefreshing];
            }
        }else{
            NSLog(@"美食专题获取数据失败");
        }
    }];
}

#pragma mark - 初始化相关
- (void)readyInit{
    _page = 1;
}

#pragma mark - 上/下拉刷新
- (void)addRefresh{
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        _page = 1;
        [weakSelf loadData];
    } dateKey:@"ZYZTopViewController"];
    
    [_tableView addFooterWithCallback:^{
        weakSelf.page++;
        [weakSelf loadData];
    }];
}


#pragma mark - 创建表格视图
- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:210/256.0 green:238/256.0 blue:119/256.0 alpha:1];
    [self.view addSubview:_tableView];
}
#pragma mark 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ZYZTopTableViewCell";
    ZYZTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZYZTopTableViewCell" owner:self options:nil] firstObject];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:210/256.0 green:238/256.0 blue:119/256.0 alpha:1];
    [cell setCellWithModel:_dataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZYZTopDetailViewController *vc = [[ZYZTopDetailViewController alloc] init];
    ZYZTopModel *model = _dataArray[indexPath.row];
    vc.cellID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
