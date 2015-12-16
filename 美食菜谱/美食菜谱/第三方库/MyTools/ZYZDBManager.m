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
    // 有了这个后，方法中有FMDatabase参数，所以就不需要再定义FMDatabase
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
// 注意，在插入的时候就可以创建表单，因为在创建的时候需要用到表单名，要字段，那么得有传入的model，创建对应的表单，所以在插入的创建！！！
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
    
    // 这方法不好操作，所以还是在上面的for循环中加上判断
    // 注意，@",_name,_price"，切分出来tempArray是三个元素
//    NSArray *tempArray = [mString componentsSeparatedByString:@","];
//    NSMutableString *tempStr = [NSMutableString string];
//    for (int j=1; j<tempArray.count; j++) {
//        [tempStr appendString:tempArray[j]];
//    }
//    NSString *sql = [NSString stringWithFormat:@"create table %@(%@)",tableName,tempStr];
//    // 打印：create table ZYZFirsrModel(_name)
//    NSLog(@"创建表单数据库语句:%@",sql);
    
    
    NSString *sql = [NSString stringWithFormat:@"create table %@(%@)",tableName,mString];
    NSLog(@"创建表单数据库语句:%@",sql);
    
    [_queue inDatabase:^(FMDatabase *db) {
        // 注意这里是executeUpdate
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
//    NSString *tableName = NSStringFromClass(model);
    // 根据对象得到类名,从而获取成员变量名以及成员类型
    NSString *tableName = [NSString stringWithUTF8String:object_getClassName(model)];
    NSArray *propertyArray = [self getPropertyListWithTableName:tableName];
    
    // 在这里创建表单
    [self createTableWithName:tableName];
    
    // insert into 表 values(?,?)
    // 可以的话，还是使用sql语句，进行填充
    NSMutableString *tempString = [NSMutableString string];
    for (int i=0; i<propertyArray.count; i++) {
        if (i == 0) {
            [tempString appendFormat:@"'%@'",[model valueForKey:propertyArray[i]]];
        }else{
            [tempString appendFormat:@",'%@'",[model valueForKey:propertyArray[i]]];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ values(%@)",tableName,tempString];
    // 注意，添加的是值，这里可以用？，也或者直接拼接，但是拼接的时候要注意加上''
//    NSLog(@"%@",sql);
    
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL isSucceed = [db executeUpdate:sql];
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
    
    NSMutableString *tempString = [NSMutableString string];
    for (int i=0; i<propertyArray.count; i++) {
        if (i == 0) {
            [tempString appendFormat:@"%@=?",propertyArray[i]];
        }else{
            [tempString appendFormat:@"and %@=?",propertyArray[i]];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@",tableName,tempString];
    NSLog(@"删除数据:%@",sql);
}

- (void)updateDbWithModel:(id)model{
    
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
