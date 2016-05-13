//
//  YWAddressModel.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//
/*
 `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键id',
 `mid` int(11) DEFAULT '0' COMMENT '会员id',
 `addr1` varchar(20) DEFAULT NULL COMMENT '省份',
 `addr2` varchar(20) DEFAULT NULL COMMENT '市区',
 `addr3` varchar(20) DEFAULT NULL COMMENT '区县',
 `addr4` varchar(50) DEFAULT NULL COMMENT '详细地址',
 `isdel` tinyint(4) DEFAULT '0' COMMENT '是否删除',
 `isselect` tinyint(4) DEFAULT '0' COMMENT '是否默认地址',
 `pickname` varchar(20) DEFAULT NULL COMMENT '收货人姓名',
 `pickphone` varchar(20) DEFAULT NULL COMMENT '收货人电话',
 `regtime` int(11) DEFAULT '0' COMMENT '添加时间',
 `wxname` varchar(100) DEFAULT NULL,
 `usmemo` varchar(250) DEFAULT NULL,
 PRIMARY KEY (`id`)

 */

#import <Foundation/Foundation.h>

@interface YWAddressModel : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *phone;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,assign) BOOL defualt;

@end
