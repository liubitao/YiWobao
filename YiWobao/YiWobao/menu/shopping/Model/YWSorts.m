//
//  YWSorts.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/20.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//


#import "YWSorts.h"
#import <MJExtension.h>
#import "YWGoods.h"
#import "Utils.h"


@implementation YWSorts
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
    for (NSDictionary *dict in array) {
         YWSorts *model = [self yw_objectWithKeyValues:dict];
        if (![Utils isNull:dict[@"Goods"]]) {
            NSArray *goodArray = [YWGoods yw_objectWithKeyValuesArray:dict[@"Goods"]];
            model.Goods = goodArray;
        }
        [result addObject:model];
    }
    return result;
}
@end
