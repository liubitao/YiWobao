//
//  YWGoods.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//
/*
 
 `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
 `cateid` int(11) DEFAULT '0' COMMENT '商品类别id',
 `mid` int(11) DEFAULT '0' COMMENT '服务商id(0-为商城自营)',
 `goodnum` varchar(50) DEFAULT NULL COMMENT '商品编号',
 `title` varchar(50) DEFAULT NULL COMMENT '商品名称',
 `pic` varchar(255) DEFAULT NULL COMMENT '商品图片',
 `descrition` text,
 `price` float(10,2) DEFAULT '0.00' COMMENT '商品原价格',
 `selprice` float(10,2) DEFAULT '0.00' COMMENT '折后商品价格',
 `num` int(11) DEFAULT '0' COMMENT '商品库存',
 `selnum` int(11) DEFAULT '0' COMMENT '已售数量',
 `isdel` tinyint(4) DEFAULT '0' COMMENT '是否删除（0-正常,1-删除）',
 `gstatus` tinyint(4) DEFAULT '0' COMMENT '商品状态（0-待审核,1-在售,2-下架,3-违规拉黑）',
 `regtime` int(11) DEFAULT '0' COMMENT '商品添加时间',
 `isself` tinyint(4) DEFAULT '0' COMMENT '是否安照自己的比率分润',
 `pre1` float(11,4) DEFAULT '0.0000',
 `pre2` float(11,4) DEFAULT '0.0000',
 `pre3` float(11,4) DEFAULT '0.0000',
 `istop` tinyint(4) DEFAULT '0',
 `syspre` float(11,4) DEFAULT '0.0000',
 `sorts` int(11) DEFAULT '0' COMMENT '排序',

 */
#import <Foundation/Foundation.h>

@interface YWGoods : NSObject

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *cateid;//商品类别id

@property (nonatomic,copy) NSString *mid;//服务商id(0-为商城自营)

@property (nonatomic,copy) NSString *goodnum;//商品编号

@property (nonatomic,copy) NSString *title;//商品名称

@property (nonatomic,copy) NSString *pic;//商品图片

@property (nonatomic,copy) NSString *price;//商品原价格

@property (nonatomic,copy) NSString *selprice;//折后商品价格

@property (nonatomic,copy) NSString *num;//商品库存

@property (nonatomic,copy) NSString *selnum;//已售数量

@property (nonatomic,copy) NSString *isdel;//是否删除（0-正常,1-删除）

@property (nonatomic,copy) NSString *gstatus;//商品状态（0-待审核,1-在售,2-下架,3-违规拉黑）

@property (nonatomic,copy) NSString *regtime;//商品添加时间


+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;

@end
