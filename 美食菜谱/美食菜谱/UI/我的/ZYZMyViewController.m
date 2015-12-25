//
//  ZYZMyViewController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZMyViewController.h"
#import "ZYZMyCollectionViewController.h"

@interface ZYZMyViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ZYZMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNac];
    
    [self createTableview];
}

#pragma mark - 表格视图代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 4;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 2;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"我的设置";
    }
    else if (section == 1){
        return @"关于我们";
    }
    else{
        return @"清除缓存";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"QF";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {//第一组
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.textLabel.text = @"我的收藏";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"ic_personal_wallet"];
        }
    }else if (indexPath.section == 1){//第二组
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于作者";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"set_ico_date"];
        }else{
            cell.textLabel.text = @"联系方式";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"ic_wuliu_tel"];
        }
    }else if (indexPath.section == 2){//第三组
        cell.textLabel.text = @"清除缓存";
        cell.imageView.image = [UIImage imageNamed:@"set_ico_clear"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) { //我的收藏
        ZYZMyCollectionViewController *vc = [[ZYZMyCollectionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if (indexPath.section == 2){   // 清除缓存
        // 获取缓存大小
        CGFloat size = [[SDImageCache sharedImageCache] getSize];
        CGFloat fileSize = size/1024.0/1024.0;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"缓存大小:%.2fM",fileSize] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 点击清除
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        // 删除按钮
        // 1.清除sd缓存  1.1清除内存缓存 1.2清除磁盘缓存
        // [NSURLCache sharedURLCache] removeAllCachedResponses];
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
    }
}

#pragma mark - 创建表格视图
- (void)createTableview{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 导航栏设置
- (void)setNac{
    self.title = @"我的";
}

@end
