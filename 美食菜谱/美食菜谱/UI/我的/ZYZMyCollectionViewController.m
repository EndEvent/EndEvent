//
//  ZYZCollectionViewController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/24.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZMyCollectionViewController.h"
#import "ZYZMyCollectionCell.h"

@interface ZYZMyCollectionViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tabelView;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation ZYZMyCollectionViewController

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNac];
    
    [self getData];
    
    [self createTableView];
}

#pragma mark - 导航栏设置
- (void)setNac{
    self.title = @"我的收藏";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 20, 40, 40);
    [leftButton setImage:[UIImage imageNamed:@"icon6-1.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)leftbuttonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 表格视图
- (void)createTableView{
    _tabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    _tabelView.backgroundColor = [UIColor colorWithRed:210/256.0 green:238/256.0 blue:119/256.0 alpha:1];
    [self.view addSubview:_tabelView];
}
#pragma mark 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ZYZMyCollectionCell";
    ZYZMyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZYZMyCollectionCell" owner:self options:nil] firstObject];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithModel:_dataArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYZRecommendModel *model = _dataArray[indexPath.row];
    
    ZYZDetailWebViewController *detailVC = [[ZYZDetailWebViewController alloc] init];
    detailVC.urlid = model.ID;
    detailVC.shareTitle = model.title;
    detailVC.contentsString = model.yingyang;
    detailVC.photoUrlString = model.thumb_2;
//    detailVC.yuanLiao = model.yuanliao;
    detailVC.yuanLiao = @"";
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    // 反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 获取数据
- (void)getData{
    ZYZDBManager *dbManager = [ZYZDBManager shareDBManager];
    _dataArray = [NSMutableArray array];
    _dataArray = [dbManager selectDbWithTableName:@"ZYZCollectModel"];
}

@end
