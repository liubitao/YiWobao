//
//  YWBuyGoods.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/27.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWBuyGoods.h"
#import <MJExtension.h>
#import "YWAddressModel.h"

@implementation YWBuyGoods
// 底层便利当前的类的所有属性，一个一个归档和接档
MJCodingImplementation
+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict{
    YWBuyGoods *buyGoods = [self mj_objectWithKeyValues:dict];
    YWAddressModel *model = [YWAddressModel yw_objectWithKeyValues:dict[@"buyAddr"]];
    buyGoods.addressModel = model;
    
    return buyGoods;
}


@end
