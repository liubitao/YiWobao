//
//  YWCell3.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/18.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWCell3.h"
#import "YWModel4.h"
#import "Utils.h"

@interface YWCell3 ()

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *mome;

@end

@implementation YWCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(YWModel4 *)model{
  
    _time.text =[Utils timeWith:model.logtm];
    
    NSString *str1 = [NSString stringWithFormat:@"金额：%@米",model.cgmoney];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:str1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
                                                                                                            NSForegroundColorAttributeName:[UIColor redColor]}];
    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    
    _money.attributedText = string1;
    
    NSString *str2 = [NSString stringWithFormat:@"说明：%@",model.memo];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:str2 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],                                                                                                                                                NSForegroundColorAttributeName:[UIColor redColor]}];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    _mome.attributedText = string2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
