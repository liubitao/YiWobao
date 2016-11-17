//
//  YWClassModel.m
//  YiWobao
//
//  Created by 刘毕涛 on 2016/11/17.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWClassModel.h"
#import <MJExtension.h>

@implementation YWClassModel
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
        YWClassModel *model = [self yw_objectWithKeyValues:dict];
        [result addObject:model];
    }
    return result;
}

@end
