//
//  YWCell3.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/18.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWCell3.h"
#import "YWModel4.h"
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
    NSTimeInterval time=[model.logtm doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _time.text =[dateFormatter stringFromDate: detaildate];
    
    _money.text = [NSString stringWithFormat:@"金额：%@",model.cgmoney];
    _mome.text = [NSString stringWithFormat:@"说明：%@",model.memo];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
