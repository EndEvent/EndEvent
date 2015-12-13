//
//  ZYZRecommendModel.m
//  美食菜谱
//
//  Created by Jarvan on 15/12/12.
//  Copyright (c) 2015年 Jarvan. All rights reserved.
//

#import "ZYZRecommendModel.h"

@implementation ZYZRecommendModel

/** 防止程序崩溃*/
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


+ (NSMutableArray *)recommendModelWithDict:(NSDictionary *)dict{
    NSMutableArray *mArray = [NSMutableArray array];
    
    NSArray *array = dict[@"results"];
    for (NSDictionary *dic in array) {
        ZYZRecommendModel *model = [[ZYZRecommendModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [mArray addObject:model];
    }
    
    return mArray;
}

@end
