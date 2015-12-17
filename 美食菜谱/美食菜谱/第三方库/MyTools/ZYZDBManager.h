//
//  ZYZDBManager.m
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

/** 类方法,快速实例化对象*/
+ (instancetype)shareDBManager;

/** 增*/
- (void)insertDbWithModel:(id)model;
/** 删*/
- (void)deleteDbWithModel:(id)model;
/** 改*/
- (void)updateDbWithNewModel:(id)newModel oldModel:(id)oldModel;
/** 查*/
- (NSArray *)selectDbWithTableName:(NSString *)tableName;

@end