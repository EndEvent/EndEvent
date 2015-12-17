//
//  ZYZDBManager.m
//  FMDB封装
//
//  Created by Jarvan on 15/12/15.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZDBManager.h"

@interface ZYZDBManager ()
{
    // 线程
    FMDatabaseQueue *_queue;
}
@end


static ZYZDBManager *manager = nil;
@implementation ZYZDBManager

+ (instancetype)shareDBManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZYZDBManager alloc] init];
    });
    
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

#pragma mark - 重写父类init，打开数据库
- (instancetype)init{
    if (self = [super init]) {
        // 打开数据库
        NSString *path = [NSString stringWithFormat:@"%@/Documents/zyzDb.db",NSHomeDirectory()];
        _queue = [[FMDatabaseQueue alloc] initWithPath:path];
        NSLog(@"path:%@",path);
    }
    
    return self;
}


#pragma mark - 获取成员变量名
- (NSArray *)getPropertyListWithTableName:(NSString *)tableName{
    // 这个tableName就是模型的类名
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    // 成员变量的个数
    unsigned int count;
    Ivar *vars = class_copyIvarList(NSClassFromString(tableName), &count);
    
    for (int i=0; i<count; i++) {
        Ivar var = vars[i];
        
        // 获取成员变量名
        NSString *property = [NSString stringWithUTF8String:ivar_getName(var)];
        [propertyArray addObject:property];
    }
    
    
    return propertyArray;
}

#pragma mark - 创建表单
- (void)createTableWithName:(NSString *)tableName{
    // create table 表名(字段名，字段名···)
    /**
     创建表单名就是类名，可以通过类名，获取对应的字段名，通过tableName获取对应模型的类名
     */
    // 获取一个类的成员变量名以及成员类型(模型类)
    NSArray *propertyArray = [self getPropertyListWithTableName:tableName];
    
    // 数据库语句的拼接
    NSMutableString *mString = [NSMutableString string];
    for (int i=0; i<propertyArray.count; i++) {
        if (i == 0) {   // 即开始第一个是没有","
            [mString appendFormat:@"%@",propertyArray[i]];
        }else{
            [mString appendFormat:@",%@",propertyArray[i]];
        }
        
    }
    
    NSString *sql = [NSString stringWithFormat:@"create table %@(%@)",tableName,mString];

    [_queue inDatabase:^(FMDatabase *db) {
        BOOL isSucceed = [db executeUpdate:sql];
        if (isSucceed) {
            NSLog(@"创建表单成功");
        } else {
            NSLog(@"已经存在/创建失败");
        }
    }];
}

#pragma mark - 插入数据
- (void)insertDbWithModel:(id)model{
    // 注意这个方法是通过类，获取类名
    NSString *tableName = [NSString stringWithUTF8String:object_getClassName(model)];
    NSArray *propertyArray = [self getPropertyListWithTableName:tableName];
    
    // 在这里创建表单
    [self createTableWithName:tableName];
    
    // insert into 表 values(?,?)
    NSMutableString *tempString = [NSMutableString string];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (int i=0; i<propertyArray.count; i++) {
        if (i == 0) {
            [tempString appendFormat:@"?"];
        }else{
            [tempString appendFormat:@",?"];
        }
        // 将values(?,?)对应的值存入数组中
        [valueArray addObject:[model valueForKey:propertyArray[i]]];
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ values(%@)",tableName,tempString];
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL isSucceed= [db executeUpdate:sql withArgumentsInArray:valueArray];
        if (isSucceed ) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }];
}

#pragma mark - 删除数据
- (void)deleteDbWithModel:(id)model{
    // delete from 表名 where 字段
    NSString *tableName = [NSString stringWithUTF8String:object_getClassName(model)];
    NSArray *propertyArray = [self getPropertyListWithTableName:tableName];
    
    NSMutableString *keyString = [NSMutableString string];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (int i=0; i<propertyArray.count; i++) {
        if (i == 0) {
            [keyString appendFormat:@"%@=?",propertyArray[i]];
        }else{
            // 注意这里的空格
            [keyString appendFormat:@" and %@=?",propertyArray[i]];
        }
        
        // 删除数据:delete from ZYZFirsrModel where _name=? and _price=?
        [valueArray addObject:[model valueForKey:propertyArray[i]]];
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@",tableName,keyString];
    
    // 注意数据库语句中是带有参数的
    [_queue inDatabase:^(FMDatabase *db) {
        // 注意:执行sql语句中是如何带入参数
        BOOL isSucceed = [db executeUpdate:sql withArgumentsInArray:valueArray];
        if (isSucceed) {
            NSLog(@"删除数据成功");
        }else{
            NSLog(@"删除数据失败");
        }
    }];
}

#pragma mark - 更新
- (void)updateDbWithNewModel:(id)newModel oldModel:(id)oldModel{
    NSString *tableName = [NSString stringWithUTF8String:object_getClassName(newModel)];
    NSArray *propertyArray = [self getPropertyListWithTableName:tableName];
    
    // update 表名 set 字段名=值 where 字段名=值(条件)
    NSMutableString *tempString1 = [NSMutableString string];
    NSMutableString *tempString2 = [NSMutableString string];
    // 存储新值
    NSMutableArray *valueArray1 = [NSMutableArray array];
    // 存储旧值
    NSMutableArray *valueArray2 = [NSMutableArray array];
    for (int i=0; i<propertyArray.count; i++) {
        if (i == 0) {
            // 字段名=值 and 字段名=值
            // %@=值 and %@=值
            // %@=? and %@=?
            [tempString1 appendFormat:@"%@=?",propertyArray[i]];
            [tempString2 appendFormat:@"%@=?",propertyArray[i]];
        }else{
            [tempString1 appendFormat:@",%@=?",propertyArray[i]];
            [tempString2 appendFormat:@" and %@=?",propertyArray[i]];
        }
        
        [valueArray1 addObject:[newModel valueForKey:propertyArray[i]]];
        [valueArray2 addObject:[oldModel valueForKey:propertyArray[i]]];
    }
    
    NSMutableArray *valueArray = [NSMutableArray arrayWithArray:valueArray1];
    for (int i=0; i<valueArray2.count; i++) {
        [valueArray addObject:valueArray2[i]];
    }
    
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ where %@",tableName,tempString1,tempString2];
    NSLog(@"更新数据:%@",sql);
    
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL isSucceed = [db executeUpdate:sql withArgumentsInArray:valueArray];
        if (isSucceed) {
            NSLog(@"数据更新成功");
        }else{
            NSLog(@"数据更新失败");
        }
    }];
}



#pragma mark - 搜索
// 直接返回模型数据
- (NSArray *)selectDbWithTableName:(NSString *)tableName{
    NSMutableArray *selectArray = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
    NSArray *propertyArray = [self getPropertyListWithTableName:tableName];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            // 表名即类名
            // 通过类名获取该类，即实例化模型
            Class class = NSClassFromString(tableName);
            id model = [[class alloc] init];
            
            // 注意，搜索出的是完整数据，之后遍历操作将模型赋值
            for (int i=0; i<propertyArray.count; i++) {
                [model setValue:[result stringForColumn:propertyArray[i]] forKey:propertyArray[i]];
            }
            
            // 添加到数组中
            [selectArray addObject:model];
        }
    }];
    
    return selectArray;
}

@end
