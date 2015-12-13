//
//  NSFileManager+ZYZ.h
//  19-http封装-block
//
//  Created by Jarvan on 15/12/3.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ZYZ)

/** 时间判断*/
- (BOOL)timeOutWithPath:(NSString *)path timeOut:(NSTimeInterval)time;

/** 清空缓存*/
- (void)clearCache;

@end
