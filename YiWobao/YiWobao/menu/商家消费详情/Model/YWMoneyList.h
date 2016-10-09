//
//  YWMoneyList.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMoneyList : NSObject

@property (nonatomic,copy) NSString *cgmoney;//消费金额
@property (nonatomic,copy) NSString *ID;//明细中的id
@property (nonatomic,copy) NSString *logtm;//消费时间
@property (nonatomic,copy) NSString *memo;//备注
@property (nonatomic,copy) NSString *oid;//
@property (nonatomic,copy) NSString *prebalance;
@property (nonatomic,copy) NSString *tagid;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userid;//店铺的id

+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;
+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array;
@end
