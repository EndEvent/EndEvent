//
//  ZYZHttpRequestBlock.m
//  19-http封装-block
//
//  Created by Jarvan on 15/12/2.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZHttpRequestBlock.h"

// MD5
#import "MyMD5.h"

#import "NSFileManager+ZYZ.h"



@interface ZYZHttpRequestBlock ()

@property (nonatomic,strong) NSFileManager *fileManager;

@end



@implementation ZYZHttpRequestBlock

- (instancetype)initHttpRequestWithUrlStr:(NSString *)urlStr httpBlcok:(HttpBlock)httpBlock{
    if ([super init]) {
        // 要将代码块保存起来，之后要进行代码块的调用
        self.myBlcok = httpBlock;
        self.urlStr = urlStr;
        
        // 补充，缓存操作
        /**
         当第一次下拉刷新的时候，进行网络请求下载数据，而当第二次下拉操作的时候呢，且两个操作间隔很短？第二次下拉操作这都不需要再次进行网络请求，即加判断操作；
         
         文件的存储，文件不能太直白；
         MD5加密，例如在下载文件的时候校验码；
         加密(非对称加密)操作，在这里使用MD5加密算法，对文件名加密；
         */
        
        // 判断这个文件是否存在，并且是否在我规定的时间范围内，不超时
        // NSFileManager也是单例
        _fileManager = [NSFileManager defaultManager];
        // Exists 存在
        /**
         给NSFileManager追加一个类别，这加上一个文件的创建时间等，是否超时的判断
         */
        if ([_fileManager fileExistsAtPath:[MyMD5 md5:urlStr]] && [_fileManager timeOutWithPath:[MyMD5 md5:urlStr] timeOut:60*60]) {    // 判断文件时候文字
            
            // 使用缓存
            NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[MyMD5 md5:urlStr]];
            _downloadData = [NSMutableData dataWithContentsOfFile:path];
            
            // 解析
            [self jsonValue];
        }else{
            // 发起异步请求
            _connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] delegate:self];
        }
        
    }
    
    return self;
}

#pragma mark - 网络请求代理方法
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"获取数据失败");
    
    if (self.myBlcok) {
        // 获取数据失败，返回为NO
        self.myBlcok(NO,self);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_downloadData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    // 与服务器连接成功，数据初始化
    _downloadData = [NSMutableData dataWithCapacity:0];
    
    // 如果_downloadData已经初始化了，但原来有旧数据，如何清空？
//    [_downloadData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // 数据解析
//    [self jsonValue];
    
    // 数据保存，数据解析
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[MyMD5 md5:_urlStr]];
    // 写入文件
    [_downloadData writeToFile:path atomically:YES];
    
    [self jsonValue];
}

// JSON解析操作
- (void)jsonValue{
    // 数据解析
    id result = [NSJSONSerialization JSONObjectWithData:_downloadData options:NSJSONReadingMutableContainers error:nil];
    
    // 默认就是认为是JSON数据类型，所以直接进行了JSON数据格式转为OC类型，即此时只有两种情况，返回要么数组，要么是字典
    if ([result isKindOfClass:[NSArray class]]) {   // 数组
        _dataArray = result;
    }else{
        if ([result isKindOfClass:[NSDictionary class]]) {   // 字典
            _dataDict = result;
        }else{
            // 如果还不是字典，就是UIImage
            _dataImage = [UIImage imageWithData:_downloadData];
        }
    }
    
    
    // 代码块的调用
    if (self.myBlcok) {
        self.myBlcok(YES,self);
    }
}

@end
