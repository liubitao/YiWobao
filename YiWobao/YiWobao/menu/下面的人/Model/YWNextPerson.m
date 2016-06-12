//
//  YWNextPerson.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/6/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWNextPerson.h"
#import <MJExtension.h>

@implementation YWNextPerson
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
        YWNextPerson *model = [self yw_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}

@end
