//
//  ZYZKindViewController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZKindViewController.h"
#import "ZYZKindListViewController.h"

@interface ZYZKindViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *fenleiArray;
@property (nonatomic,strong) NSArray *renqunArray;
@property (nonatomic,strong) NSArray *gongxiaoArray;
@property (nonatomic,strong) NSArray *badacaixiArray;
@property (nonatomic,strong) NSArray *qitaArray;
@property (nonatomic,strong) NSArray *allKeyWordArray;
@property (nonatomic,strong) UITableView *tableView;
@end



@implementation ZYZKindViewController

- (instancetype)init{
    if (self = [super init]) {
        // 相关初始化
        _fenleiArray = @[@"早餐",@"荤菜",@"素菜",@"西餐",@"主食粉面",@"靓汤",@"家常菜",@"特色小吃",@"凉菜",@"烘焙",@"炖菜",@"烤箱",@"微波炉",@"时尚饮品",@"食疗药膳",@"粥"];
        _renqunArray = @[@"0—1岁",@"1—3岁",@"3—6岁",@"瘦身餐",@"家庭餐",@"美容餐",@"孕期餐",@"月子餐",@"懒人餐"];
        _gongxiaoArray = @[@"补气养血",@"美容养颜",@"减肥瘦身",@"益智补脑",@"清热去火",@"健脾开胃",@"滋阴润燥",@"安神助眠",@"三高调养"];
        _badacaixiArray = @[@"鲁菜",@"苏菜",@"粤菜",@"川菜",@"浙菜",@"闽菜",@"湘菜",@"徽菜"];
        _qitaArray = @[@"石锅拌饭",@"红烧鱼",@"南瓜饼",@"饭团",@"江西菜",@"东北菜",@"面",@"汤",@"糖尿病",@"高血压",@"胃炎",@"肠炎",@"咽炎",@"鼻炎",@"肺炎",@"肾炎",@"肝炎"];
        
        _allKeyWordArray = @[_fenleiArray,_renqunArray,_gongxiaoArray,_badacaixiArray,_qitaArray];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
}

#pragma mark - 创建表格视图
- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 表格视图代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ZYZKindViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NSArray *array = _allKeyWordArray[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
    
    
    NSString *imageName = [NSString stringWithFormat:@"%ld.png",indexPath.row+1];
//    cell.imageView.image = [UIImage imageNamed:imageName];
    // 图片太大，但不能直接修改imageView
    UIImage *icon = [UIImage imageNamed:imageName];
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZYZKindListViewController *kindListVC = [[ZYZKindListViewController alloc] init];
    // 关键字
    kindListVC.keyWord = _allKeyWordArray[indexPath.section][indexPath.row];
    // 组号（第几组）
    kindListVC.sectionNumber = indexPath.section;
    [self.navigationController pushViewController:kindListVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 分组
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"特色分类";
    }else if (section == 1){
        return @"适宜人群";
    }else if (section == 2){
        return @"功效食物";
    }else if (section == 3){
        return @"中国名菜";
    }else{
        return @"其他分类";
    }
}

// 分组对应的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _allKeyWordArray[section];
    return array.count;
}

// 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _allKeyWordArray.count;
}

@end
