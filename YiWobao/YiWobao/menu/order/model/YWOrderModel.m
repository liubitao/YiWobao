//
//  YWOrderModel.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWOrderModel.h"
#import <MJExtension.h>
#import "YWGoods.h"
@implementation YWOrderModel

// 底层便利当前的类的所有属性，一个一个归档和接档
MJCodingImplementation
+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict{
    
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id",
                 };
    }];
    YWOrderModel *model = [self mj_objectWithKeyValues:dict];
    
    YWGoods *goods =[YWGoods yw_objectWithKeyValues:dict[@"Goods"]];
    model.goods = goods;
    
    return model;
}
@end