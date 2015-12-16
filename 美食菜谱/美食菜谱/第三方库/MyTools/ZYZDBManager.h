//
//  ZYZDBManager.h
//  FMDB封装
//
//  Created by Jarvan on 15/12/15.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
// 线程安全
#import "FMDatabaseQueue.h"
// 使用到RunTime机制所需要包含的
#import <objc/runtime.h>



@interface ZYZDBManager : NSObject

/** 类方法*/
+ (instancetype)shareDBManager;

// 增
- (void)insertDbWithModel:(id)model;
// 删除
- (void)deleteDbWithModel:(id)model;
// 更新
- (void)updateDbWithModel:(id)model;
// 查询
- (NSArray *)selectDbWithTableName:(NSString *)tableName;


// 测试
- (void)createTableWithName:(NSString *)tableName;

@end
