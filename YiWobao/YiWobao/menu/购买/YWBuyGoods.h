//
//  YWBuyGoods.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/27.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//
/*
 buyAddr =         {
 addr1 = "\U6e56\U5357\U7701";
 addr2 = "\U6e58\U6f6d\U5e02";
 addr3 = "\U96e8\U6e56\U533a";
 addr4 = "\U4eba\U5728";
 id = 1302;
 isdel = 0;
 isselect = 1;
 mid = 8919;
 pickname = "\U5218\U6bd5\U6d9b";
 pickphone = 15068891471;
 regtime = 1464317001;
 usmemo = "<null>";
 wxname = "<null>";
 };
 
 buyGoodsBH = MZ200088;
 buyGoodsNum = 1;
 buyGoodsON = 1004160527104401118;
 buyGoodsPic = "/shop/upload/image/ywb/logo.jpg";
 buyGoodsPrice = 268;
 buyGoodsTitle = "\U5361\U5b9d\U624b\U673aPOS\U673a";
 gid = 1;
 */
#import <Foundation/Foundation.h>

@class YWAddressModel;

@interface YWBuyGoods : NSObject

@property (nonatomic,strong) YWAddressModel *addressModel;

@property (nonatomic,strong) NSString *buyGoodsBH;

@property (nonatomic,strong) NSString *buyGoodsNum;

@property (nonatomic,strong) NSString *buyGoodsON;

@property (nonatomic,strong) NSString *buyGoodsPic;

@property (nonatomic,strong) NSString *buyGoodsTitle;

@property (nonatomic,strong) NSString *gid;


+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;
@end
