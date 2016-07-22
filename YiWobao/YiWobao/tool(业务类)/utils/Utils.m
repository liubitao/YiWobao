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

+(void)timeDecrease:(UIButton *)button{
    __block int timeout=60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:@"发送验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                button .userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    
}

+(NSMutableDictionary *)paramter:(NSString *)act ID:(NSString *)ID{
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
    }else if([object isKindOfClass:[NSArray class]]){
        NSArray *array = (NSArray*)object;
        if (array.count == 0) {
            return YES;
        }
    }else if ([object isKindOfClass:[NSString class]]){
        NSString *str = (NSString *)object;
        if (str.length == 0) {
            return YES;
        }
    }
    return NO;
}

+ (CGFloat)labelWidth:(NSString *)text font:(NSInteger)font{
    
    CGRect detailSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}context:nil];
    
    return detailSize.size.width;
}

+ (NSString*)timeWith:(NSString*)timeStr{
    NSTimeInterval time=[timeStr doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate: detaildate];
}

@end
