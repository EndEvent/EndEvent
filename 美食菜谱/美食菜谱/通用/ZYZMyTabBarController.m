//
//  ZYZMyTabBarController.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZMyTabBarController.h"

@interface ZYZMyTabBarController ()

{
    NSMutableArray *mArray;
}

@end

@implementation ZYZMyTabBarController

- (instancetype)init{
    if (self = [super init]) {
        mArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (id)addViewControllerWithClassName:(NSString *)className name:(NSString *)name image:(UIImage *)image{
    Class viewController = NSClassFromString(className);
    UIViewController *vc = [[viewController alloc] init];
    vc.title = name;
    vc.tabBarItem.image = image;
    
    UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:vc];
    unc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    unc.navigationBar.tintColor = [UIColor orangeColor];
    unc.navigationBar.barTintColor = [UIColor orangeColor];
    
    [mArray addObject:unc];
    
    self.viewControllers = mArray;
    
    return vc;
}


@end
