//
//  YWFederal.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWFederal.h"
#import <MJExtension.h>
#import "YWFederalShop.h"

@implementation YWFederal

// 底层便利当前的类的所有属性，一个一个归档和接档
MJCodingImplementation
+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict{
    
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    YWFederal *model = [self mj_objectWithKeyValues:dict];
    
    NSMutableArray *money =[YWFederalShop yw_objectWithKeyValuesArray:dict[@"Shops"]];
    model.shops = money;
    return model;
}

+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array{
    NSMutableArray *result = [NSMutableArray array];
    if ([Utils isNull:array]) {
        return result;
    }
    
    for (NSDictionary *dict in array) {
        YWFederal * model = [self yw_objectWithKeyValues:dict];
        if ([model.isshow isEqualToString:@"1"]) {
            [result addObject:model];
        }
    }
    return result;
    
}
@end
