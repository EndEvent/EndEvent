//
//  ZYZTopDetailViewController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/21.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZTopDetailViewController.h"
#import "ZYZTopDetailFirstCell.h"
#import "ZYZTopDetailSecondCell.h"
#import "ZYZTopDetailModel.h"

@interface ZYZTopDetailViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;
@property (nonatomic,strong) ZYZTopDetailModel *model;
@property (nonatomic,strong) NSMutableArray *detailDictArray;
@end

@implementation ZYZTopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self readyInit];
    [self setNac];
    [self createTableView];
    [self addRefresh];
    [self loadData];
}

#pragma mark - 设置导航栏
- (void)setNac{
    self.title = @"专题列表";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 20, 40, 40);
    [leftButton setImage:[UIImage imageNamed:@"icon6-1"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)leftbuttonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载数据
- (void)loadData{
    __weak typeof(self) weakSelf = self;
    [ZYZHttpRequestBlock httpRequestWithUlrStr:[NSString stringWithFormat:@"http://ibaby.ipadown.com/api/food/food.topic.detail.php?id=%@",_cellID] httpBlcok:^(BOOL isSucceed, ZYZHttpRequestBlock *request) {
        if (isSucceed) {
            NSLog(@"专题-详情 数据加载成功");
            
            // 整个数据
            _model = [[ZYZTopDetailModel alloc] init];
            [_model setValuesForKeysWithDictionary:request.dataDict];
            
            
            // 底下数据
            NSArray *array = _model.tlist;
            NSMutableArray *mArray = [NSMutableArray array];
            _detailDictArray = [NSMutableArray array];
            for (NSDictionary *listDict in array) {
                [mArray addObject:listDict[@"list"]];
            }
            // 取出tlist[@"list"]数组中里面的全部字典
            for (NSInteger i = 0 ; i < mArray.count; i ++) {
                for (NSDictionary *dict in mArray[i]) {
                    [_detailDictArray addObject:dict];
                }
            }
            
            [weakSelf.tableView reloadData];
            
            if (weakSelf.page == 1) {
                [weakSelf.tableView headerEndRefreshing];
            }else{
                [weakSelf.tableView footerEndRefreshing];
            }
        }else{
            NSLog(@"专题-详情 数据加载失败");
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
    [self.view addSubview:_tableView];
}
#pragma mark 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
    return _detailDictArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identify = @"ZYZTopDetailFirstCell";
        ZYZTopDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZYZTopDetailFirstCell" owner:self options:nil] firstObject];
        }
        [cell setCellWithModel:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:210/256.0 green:238/256.0 blue:119/256.0 alpha:1];
        return cell;
    }else{
        static NSString *identify = @"ZYZTopDetailSecondCell";
        ZYZTopDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZYZTopDetailSecondCell" owner:self options:nil] firstObject];
        }
        cell.backgroundColor = [UIColor colorWithRed:210/256.0 green:238/256.0 blue:119/256.0 alpha:1];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellWithDictionary:_detailDictArray[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 265;
    }else{
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"---");
    if (indexPath.row == 0) {
        return;
    }else{
        ZYZDetailWebViewController *vc = [[ZYZDetailWebViewController alloc] init];
        vc.urlid = _detailDictArray[indexPath.row][@"ID"];
        vc.shareTitle = _detailDictArray[indexPath.row][@"title"];
        vc.contentsString = _detailDictArray[indexPath.row][@"effect"];
        vc.photoUrlString = _detailDictArray[indexPath.row][@"thumb_2"];
        vc.yuanLiao = _detailDictArray[indexPath.row][@"effect"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    }else{
        return @"美食列表";
    }
}

@end
