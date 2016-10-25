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
//判断对象是不是空的
+(BOOL)isNull:(id)object;

+(NSMutableDictionary *)paramter:(NSString *)act ID:(NSString *)ID;
//计算字符串的长度
+ (CGFloat)labelWidth:(NSString *)text font:(NSInteger)font height:(CGFloat)height;
//时间戳转化为时间
+ (NSString*)timeWith:(NSString*)time;

+ (NSMutableAttributedString *)stringWith:(NSString *)string font1:(UIFont*)font1 color1:(UIColor *)color1 font2:(UIFont*)font2 color2:(UIColor *)color2 range:(NSRange)range;

@end
