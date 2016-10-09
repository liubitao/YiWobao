//
//  YWShop.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWShop : NSObject
@property (nonatomic,copy) NSString *phones;//电话
@property (nonatomic,copy) NSString *skewm;//二维码
@property (nonatomic,copy) NSString *titlename;//店名
@property (nonatomic,copy) NSString *totalmoney;//消费金额
@property (nonatomic,copy) NSString *username;//店主
@property (nonatomic,strong) NSArray *monyelist;
@property (nonatomic,copy) NSString *ybkind;
+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;
@end
