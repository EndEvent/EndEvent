//
//  ZYZMyTabBarController.h
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYZMyTabBarController : UITabBarController

- (id)addViewControllerWithClassName:(NSString *)className
                                  name:(NSString *)name
                                 image:(UIImage *)image;

@end
