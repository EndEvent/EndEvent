//
//  AppDelegate.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 状态栏的设置
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 视图控制器的添加
    ZYZMyTabBarController *tbc = [[ZYZMyTabBarController alloc] init];
    tbc.tabBar.barTintColor = [UIColor orangeColor];
    tbc.tabBar.tintColor = [UIColor whiteColor];
    
    ZYZRecommendViewController *vc1 = [tbc addViewControllerWithClassName:@"ZYZRecommendViewController" name:@"食神推荐" image:[UIImage imageNamed:@"item-me"]];
    vc1.view.backgroundColor = [UIColor whiteColor];
    
    ZYZKindViewController *vc2 = [tbc addViewControllerWithClassName:@"ZYZKindViewController" name:@"美食分类" image:[UIImage imageNamed:@"item-cook"]];
    vc2.view.backgroundColor = [UIColor whiteColor];
    
    ZYZTopViewController *vc3 = [tbc addViewControllerWithClassName:@"ZYZTopViewController" name:@"美食专题" image:[UIImage imageNamed:@"item-topic"]];
    vc3.view.backgroundColor = [UIColor whiteColor];
    
    ZYZMyViewController *vc4 = [tbc addViewControllerWithClassName:@"ZYZMyViewController" name:@"我的" image:[UIImage imageNamed:@"item-yuan"]];
    vc4.view.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = tbc;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
