//
//  YWdetails.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/24.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWdetails.h"
#import "Utils.h"

@interface YWdetails ()
@property (weak, nonatomic) IBOutlet UILabel *surplus;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_height;
@property (weak, nonatomic) IBOutlet UILabel *totalmoney;
@property (weak, nonatomic) IBOutlet UILabel *turemoney;
@property (weak, nonatomic) IBOutlet UILabel *plan;
@property (weak, nonatomic) IBOutlet UILabel *renz;
@property (weak, nonatomic) IBOutlet UILabel *minNumber;
@property (weak, nonatomic) IBOutlet UILabel *maxNumber;
@property (weak, nonatomic) IBOutlet UILabel *demand;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *claimHeight;
@property (weak, nonatomic) IBOutlet UIButton *claim_b;


@end
@implementation YWdetails


- (void)setModel:(YWWelfare *)welfare{
    // 视图内容布局
    CGRect detailSize = [welfare.title boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:23]}context:nil];
   
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time=[dat timeIntervalSince1970];
    if ([welfare.isback isEqualToString:@"1"]) {
        _surplus.text = @"回购中";
    }else{
        if ([welfare.stsc isEqualToString:@"0"]||[welfare.isend isEqualToString:@"1"]||[welfare.truemoney floatValue]>=[welfare.totalmoney floatValue]||[welfare.endtm floatValue]<= time ) {
           _surplus.text = @"已结束";
           
        }else{
            float i = [welfare.endtm floatValue] - time;
            NSString *str = [NSString stringWithFormat:@"剩余%.0f天",i/60/60/24+1];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
            [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 2)];
            [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(string2.length-1, 1)];
            _surplus.attributedText = string2;
        }
    }
    
    _title_height.constant = detailSize.size.height;
    
    _title.text = welfare.title;
    
    NSString *str1 = [NSString stringWithFormat:@"%.0f元",[welfare.totalmoney floatValue]];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:str1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(str1.length-1, 1)];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(str1.length-1, 1)];
    _totalmoney.attributedText = string1;
    
    NSString *str2 = [NSString stringWithFormat:@"%.0f元",[welfare.truemoney floatValue]];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:str2 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(str2.length-1, 1)];
    [string2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(str2.length-1, 1)];
    _turemoney.attributedText = string2;
    
    NSString *str3 = [NSString stringWithFormat:@"%.2f%%",[welfare.truemoney floatValue]/[welfare.totalmoney floatValue]*100];
    
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:str3 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
    [string3 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(str3.length-1, 1)];
    [string3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(str3.length-1, 1)];
    _plan.attributedText = string3;

    NSString *str4 = [NSString stringWithFormat:@"认证机构：%@",welfare.startman];
    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc]initWithString:str4 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
    [string4 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    _renz.attributedText = string4;
    
    NSString *str5 = [NSString stringWithFormat:@"最小认领数：%@份",welfare.sprice];
    NSMutableAttributedString *string5 = [[NSMutableAttributedString alloc]initWithString:str5 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
    [string5 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 6)];
    _minNumber.attributedText = string5;
    
    NSString *str6 = [NSString stringWithFormat:@"最大认领数：%@份",welfare.topprice];
    NSMutableAttributedString *string6 = [[NSMutableAttributedString alloc]initWithString:str6 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
    [string6 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 6)];
    _maxNumber.attributedText = string6;
    _claimHeight.constant = 30;
    if ([Utils isNull:welfare.claimArray]) {
        _claimHeight.constant = 0;
        _claim_b.hidden = YES;
    }
    
    NSString *str7 ;
    if ([welfare.canget isEqualToString:@"0"]) {
        str7 = @"认领要求：不限制";
        
    }else if ([welfare.canget isEqualToString:@"1"]){
        str7 = @"认领要求：众创领袖以上才能购买";
    }else if([welfare.canget isEqualToString:@"2"]){
        str7 = @"认领要求：事业董事才能购买";
    }
    NSMutableAttributedString *string7 = [[NSMutableAttributedString alloc]initWithString:str7 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
    [string7 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
    _demand.attributedText = string7;
    
}

- (void)pushClaim:(PushClaim)pushClaim{
    self.pushClaim = pushClaim;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (IBAction)push:(id)sender {
    if (self.pushClaim != nil ) {
        self.pushClaim();
    }
}


@end
