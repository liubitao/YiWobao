//
//  YWShop.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWShop.h"
#import "YWMoneyList.h"
#import <MJExtension.h>
#import "Utils.h"
@implementation YWShop

// 底层便利当前的类的所有属性，一个一个归档和接档
MJCodingImplementation
+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict{
    
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    YWShop *model = [self mj_objectWithKeyValues:dict];
    
    NSMutableArray *money =[YWMoneyList yw_objectWithKeyValuesArray:dict[@"moneylist"]];
    model.monyelist = money;
    return model;
}

@end
