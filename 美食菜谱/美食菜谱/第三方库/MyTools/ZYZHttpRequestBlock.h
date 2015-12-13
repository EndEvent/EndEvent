//
//  ZYZHttpRequestBlock.h
//  19-http封装-block
//
//  Created by Jarvan on 15/12/2.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZYZHttpRequestBlock;


/** 定义代码块类型*/
typedef void(^HttpBlock)(BOOL isSucceed, ZYZHttpRequestBlock *request);



@interface ZYZHttpRequestBlock : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>

/** 对象方法，实例化对象，并将具体操作封装到代码块中*/
- (instancetype)initHttpRequestWithUrlStr:(NSString *)urlStr  httpBlcok:(HttpBlock)httpBlock;

/** 代码块，具体操作*/
@property (nonatomic,copy) HttpBlock myBlcok;
/** 请求地址*/
@property (nonatomic,copy) NSString *urlStr;


// 请求
/** 发送请求*/
@property (nonatomic,strong) NSURLConnection *connection;
/** 获取到的数据*/
@property (nonatomic,strong) NSMutableData *downloadData;


// 解析结果
/** 数组数据*/
@property (nonatomic,strong) NSArray *dataArray;
/** 字典数据*/
@property (nonatomic,strong) NSDictionary *dataDict;
/** 图片数据*/
@property (nonatomic,strong) UIImage *dataImage;


@end
