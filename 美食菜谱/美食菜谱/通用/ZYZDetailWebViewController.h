//
//  ZYZDetailWebViewController.h
//  美食菜谱
//
//  Created by Jarvan on 15/12/15.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYZDetailWebViewController : UIViewController

@property (nonatomic,strong)NSString *urlid;
/** 传title过去，用于设置分享的标题*/
@property (nonatomic,strong)NSString *shareTitle;
/** 传内容过去，用于设置分享所显示的内容，这里的内容用的是模型中的“yingyang”*/
@property (nonatomic,strong)NSString *contentsString;
/** 图片链接，用于设置分享所显示的图片*/
@property (nonatomic,strong)NSString *photoUrlString;
/** 传原料过来，用作收藏表单设置*/
@property (nonatomic,strong)NSString *yuanLiao;

@end
