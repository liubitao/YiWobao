//
//  YWUser.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/6.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//
//addrs = "<null>";                                     用户的地址
//bankaccount = "<null>";
//bankname = "<null>";
//banknum = "<null>";
//birthday = 0;                                         用户生日
//chmoney = "0.00";                                     嗨币
//id = 8919;                                            主键自增id
//isdel = 0;                                            0-正常,1删除
//logcount = 1;                                         登录次数
//logpwd = e10adc3949ba59abbe56e057f20f883e;            登录密码
//logtime = 1460529740;                                 最近登录时间
//openid = "oRvKxs3O_Tqz7Auf3ciPq99DTz3M";              微信openid
//paypwd = "<null>";                                    支付密码
//phone = 555555555;                                    用户（电话）帐号
//pid = 1;                                              顶级id
//regtime = 1458725946;                                 注册时间
//shopname = "<null>";                                  商铺名称
//tjrname = "\U90ed\U90ed";
//tjrphone = 18905811712;
//tjrwxname = "\U90ed\U8fdc\U950b";
//userimg = "http://wx.qlogo.cn/mmopen/eytJa9K5jkpmZOZ9RD90ib1QFWQp6hSfW0A1LbbUAdsRAMkXLW7PvxJwF7bj6vmZdVB6icIelavX4UFSXgjl3tPVDibTbndRmsH/0";                     用户头像
//userkind = 1;                                         0-游客，1-事业董事，2-创业领袖
//username = 155581452255;                              用户姓名
//usersex = 1;                                          用户性别（1-男，0-女）
//weixin = "<null>";                                     微信号
//wxname = "\U6e6e\U706d&\U5c18\U4e8b";                  微信昵称
//"zc_g1" = 0;                                           总裁数/直推会员数
//"zc_g2" = "<null>";
//"zc_g3" = "<null>";
//"sr_0" = "194054.96";                                  总收益
//"sr_7" = "171850.15";                                  七天收益

#import <Foundation/Foundation.h>

@interface YWUser : NSObject


@property (nonatomic,copy) NSString *username;//用户姓名

@property (nonatomic,copy) NSString *usersex;//用户性别（1-男，0-女）

@property (nonatomic,copy) NSString *addrs;//地址

@property (nonatomic,copy) NSString *wxname;//微信昵称

@property (nonatomic,copy) NSString *userimg;//用户头像

@property (nonatomic,copy) NSString *bankaccount; //银行卡注册人

@property (nonatomic,copy) NSString *bankname;//银行名字

@property (nonatomic,copy) NSString *banknum;//银行卡账号

@property (nonatomic,copy) NSString *birthday;//生日

@property (nonatomic,copy) NSString *chmoney;//米币

@property (nonatomic,copy) NSString *ID;//用户编号

@property (nonatomic,copy) NSString *logpwd;//登录密码

@property (nonatomic,copy) NSString *paypwd;//支付密码

@property (nonatomic,copy) NSString *phone;//用户电话

@property (nonatomic,copy) NSString *userkind;//用户类型0-游客，1-事业董事，2-创业领袖

@property (nonatomic,copy) NSString *tjrname;//推荐人名字

@property (nonatomic,copy) NSString *tjrphone;//推荐人的电话

@property (nonatomic,copy) NSString *tjrwxname;//推荐人的微信名

@property (nonatomic,copy) NSString *pid;//顶级id

@property (nonatomic,copy) NSString *sr_7;//七天收益

@property (nonatomic,copy) NSString *sr_0;//总收益

@property (nonatomic,copy) NSString *zc_g1;//总裁数

@property (nonatomic,copy) NSString *zc_g2;

@property (nonatomic,copy) NSString *zc_g3;



+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;



@end
