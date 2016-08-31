//
//  YWWelfare.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/7/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWclaimModel.h"

@interface YWWelfare : NSObject

@property (nonatomic,copy) NSString* backfit;//回购倍率
@property (nonatomic,copy) NSString* canget; //0-不限制 ，1-众创领袖以上才能购买，2-事业董事才能购买
@property (nonatomic,copy) NSString* content;//html数据 图文描述
@property (nonatomic,copy) NSString* descriptions;//项目描述
@property (nonatomic,copy) NSString* endtm; //截止日期（0-无限期）
@property (nonatomic,copy) NSString* ID; // id
@property (nonatomic,copy) NSString* img1;//图片
@property (nonatomic,copy) NSString* img2;
@property (nonatomic,copy) NSString* img3;
@property (nonatomic,copy) NSString* img4;
@property (nonatomic,copy) NSString* isback;//是否开通回购0-不回购  1-开始回购'
@property (nonatomic,copy) NSString* isdel;//是否删除（0-否，1-删除）
@property (nonatomic,copy) NSString* isend;//是否截止(0-否，1-是)
@property (nonatomic,copy) NSString* isgd;//0-不固定金额,1-固定金额
@property (nonatomic,copy) NSString* istop;//'是否置顶（0-否，1-是）
@property (nonatomic,copy) NSString* osure;//第三方认证(0-没有,1-有)
@property (nonatomic,copy) NSString* pic;//图片
@property (nonatomic,copy) NSString* pre1;//分润1
@property (nonatomic,copy) NSString* pre2;
@property (nonatomic,copy) NSString* pre3;
@property (nonatomic,copy) NSString* profit; //市盈率
@property (nonatomic,copy) NSString* regtime;//发起时间
@property (nonatomic,copy) NSString* sorts;//排序(数字越大,排前)
@property (nonatomic,copy) NSString* sprice;//单价价格
@property (nonatomic,copy) NSString* ssure;//系统认证(0-没有,1-有)
@property (nonatomic,copy) NSString* startman;//发起人
@property (nonatomic,copy) NSString* stsc;//项目状态（0-关闭，1-开启）
@property (nonatomic,copy) NSString* title;//项目名称
@property (nonatomic,copy) NSString* topprice;//'最高购买金额，0表示不限制
@property (nonatomic,copy) NSString* totalmoney;//目标金额
@property (nonatomic,copy) NSString* truemoney;//实际金额
@property (nonatomic,copy) NSString* goodsid;//商品id
@property (nonatomic,strong) NSArray* claimArray;

+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array;

@end
