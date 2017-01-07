//
//  YWclaimModel.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/30.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWclaimModel : NSObject
@property (nonatomic,copy) NSString* backfit;//回购倍率
@property (nonatomic,copy) NSString* backstsc;//0-正常持有，1-正在申请回购，2-已经回购
@property (nonatomic,copy) NSString* heardimg;//'用户头像
@property (nonatomic,copy) NSString* ID;//自增主键id
@property (nonatomic,copy) NSString* memo;//备注
@property (nonatomic,copy) NSString* mid;//投资人id
@property (nonatomic,copy) NSString* paynum;//'支付单号（pay表对于orderid）
@property (nonatomic,copy) NSString* paystsc;//支付状态
@property (nonatomic,copy) NSString* projid;//项目id
@property (nonatomic,copy) NSString* truename;//众筹人姓名
@property (nonatomic,copy) NSString* truephone;//众筹人手机
@property (nonatomic,copy) NSString* zckind;//支付类型 0-余额支付  1-微信支付 2- 后台支付'
@property (nonatomic,copy) NSString* zcmoney;//众筹金额
@property (nonatomic,copy) NSString* zcnum;//购买份额
@property (nonatomic,copy) NSString* zctime;//众筹时间
@property (nonatomic,copy) NSString* descriptions;//描述
@property (nonatomic,copy) NSString* isback;//回购
@property (nonatomic,copy) NSString* endtm;//结束时间
@property (nonatomic,copy) NSString* stsc;//项目状态（0-关闭，1-开启）
@property (nonatomic,copy) NSString* isdel;//是否删除（0-否，1-删除）
@property (nonatomic,copy) NSString* isend;//是否截止(0-否，1-是)
@property (nonatomic,copy) NSString* totalmoney;//目标金额
@property (nonatomic,copy) NSString* truemoney;//实际金额
@property (nonatomic,copy) NSString* title;

+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array;
@end
