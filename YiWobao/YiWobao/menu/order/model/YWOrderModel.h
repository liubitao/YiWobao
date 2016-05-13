//
//  YWOrderModel.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//
/*
 Address = "<null>";                                地址
 
 Goods =             {
 id = 3;
 pic = "/shop/images/index-01.jpg";
 price = "29.90";                                   商品原价格
 selprice = "29.90";                                折后商品价格
 title = "\U6211\U8981\U521b\U4e1a";
 };
 
 Member =             {
 id = 8919;
 username = "\U54df\U7684";
 wxname = "\U6e6e\U706d&\U5c18\U4e8b";
 };
 
 admid = 0;                                         服务商id
 aid = 0;                                           送货地址id
 chmoney = "0.00";                                  支付电子币
 gid = 3;                                           商品id
 id = 6892;
 memo = "\U8d2d\U4e70";                             备注
 mid = 8919;                                        会员ID
 num = 1;                                           购买数量
 ordernum = 1004160414134610841;
 otmoney = "0.00";                                  微信支付
 paykind = 1;                                       0-使用余额，1-不使用余额支付,2-他人代付,8-未选择
 paystatus = 2;                                     0-待支付，1-已支付,2-取消订单
 paytime = 0;                                       支付时间
 plcontent = "<null>";                              评论内容
 plscore = "5.0";                                   评论分值
 pltime = 0;                                        评论时间
 pmoney = "29.90";                                  购买总价
 receivetime = 0;                                   快递送达时间
 regtime = 1460612770;                              下单时间
 sendtime = 0;                                      发货时间
 suredf = 1;                                        0-拒绝，1-正常
 tjid = 0;                                          推荐人id(代付用)
 */

#import <Foundation/Foundation.h>
@class YWGoods;

@interface YWOrderModel : NSObject

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *regtime;//下单时间

@property (nonatomic,copy) NSString *num;//购买数量

@property (nonatomic,copy) NSString *pmoney; //购买总价

@property (nonatomic,strong) YWGoods *goods;//商品

@property (nonatomic,copy) NSString *paystatus; //订单状态

+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;

@end
