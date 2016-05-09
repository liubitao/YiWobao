//
//  Utils.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/5.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "Utils.h"
#import <MBProgressHUD.h>

@implementation Utils

//创建一个等待框
+ (MBProgressHUD *)createHUD
{
    //取出最后的一个窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.dimBackground = YES;
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    return HUD;
    
}

//检测手机号码
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
    
}

//验证银行卡号
+ (BOOL) checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }        allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

+(NSMutableDictionary *)paramter:(NSString *)act id:(NSString *)ID{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[act MD5Digest],sKey]MD5Digest];
    parameter[@"bhim"] = [[ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    return parameter;
}


+(BOOL)isNull:(id)object{
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }else if([object isKindOfClass:[NSNull class]]){
        return YES;
    }else if (object == nil){
        return YES;
    }else if ([object isKindOfClass:[NSString class]]){
        NSString *str = (NSString *)object;
        if (str.length == 0) {
            return YES;
        }
    }
    return NO;
}

@end
