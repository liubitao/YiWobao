//
//  YWGoods.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWGoods.h"
#import <MJExtension.h>
#import "Utils.h"
@implementation YWGoods

// 底层便利当前的类的所有属性，一个一个归档和接档
MJCodingImplementation
+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict{
    
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    
    return [self mj_objectWithKeyValues:dict];
}

+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray array];
    if ( [Utils isNull:array]) {
        return result;
    }
    for (NSDictionary *dict in array) {
        YWGoods *model = [self yw_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}

@end
