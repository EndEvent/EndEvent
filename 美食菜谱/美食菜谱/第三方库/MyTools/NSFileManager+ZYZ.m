//
//  NSFileManager+ZYZ.m
//  19-http封装-block
//
//  Created by Jarvan on 15/12/3.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "NSFileManager+ZYZ.h"

@implementation NSFileManager (ZYZ)

- (BOOL)timeOutWithPath:(NSString *)path timeOut:(NSTimeInterval)time{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 路径
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    
    
    NSDictionary *fileMessage = [fileManager attributesOfItemAtPath:filePath error:nil];
    // 读取出创建的时间
    NSDate *createDate = [fileMessage objectForKey:NSFileCreationDate];
    // 现在的时间
    NSDate *date = [NSDate date];
    
    // 计算出两个时间差值
    NSTimeInterval fileTime = [date timeIntervalSinceDate:createDate];
    
    if (fileTime > time) {
        return NO;
    }else{
        return YES;
    }
}

- (void)clearCache{
    NSString *path = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    
    // 获取该文件夹下的所有目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    // 遍历数组，依次删除，2种方式
//    for (NSString *fileName in array) {
//        NSString *newPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
//        [fileManager removeItemAtPath:newPath error:nil];
//    }
    
    // 但是这些操作有问题，当数据量大的时候，会阻塞主线程
    // 方法二，枚举遍历，使用block开辟一条线程，在线程中遍历
    /**
     obj:遍历对象
     idx:第几位
     stop:是否停止
     */
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *newPath = [NSString stringWithFormat:@"%@/%@",path,obj];
        [fileManager removeItemAtPath:newPath error:nil];
    }];
    
    
    // 扩展，数组有枚举遍历，字典也有
    /**
     key:字典的key
     obj:字典的value
     */
    NSDictionary *dic;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
    }];
}

@end
