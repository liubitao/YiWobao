//
//  Utils.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/5.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface Utils : NSObject

+ (MBProgressHUD *)createHUD;

//检查手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

//检查银行卡号
+ (BOOL)checkCardNo:(NSString*) cardNo;

//倒计时
+(void)timeDecrease:(UIButton *)button;

+(BOOL)isNull:(id)object;

+(NSMutableDictionary *)paramter:(NSString *)act ID:(NSString *)ID;
@end
