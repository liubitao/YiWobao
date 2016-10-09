//
//  YWheaderView.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWheaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface YWheaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *income;
@end

@implementation YWheaderView
- (void)setModel:(YWShop *)shop{
    [_pic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,shop.skewm]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _shopName.text = [NSString stringWithFormat:@"店主:%@",shop.username];
    _name.text = [NSString stringWithFormat:@"商户名称:%@",shop.titlename];
    _income.text = [NSString stringWithFormat:@"总收入:%@米",shop.totalmoney];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
