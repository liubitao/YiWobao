//
//  YWgoodsCell.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/20.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWgoodsCell.h"
#import "YWGoods.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"

@interface YWgoodsCell ()


@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *oldPrice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width2;
@property (weak, nonatomic) IBOutlet UILabel *sale;
@property (weak, nonatomic) IBOutlet UIButton *buy_btn;


@end

@implementation YWgoodsCell



- (void)awakeFromNib {
    [super awakeFromNib];
    _buy_btn.layer.cornerRadius = 5;
    _buy_btn.layer.masksToBounds = YES;
    
}

- (void)setCellModel:(YWGoods *)model{
    
    NSString *picStr = [NSString stringWithFormat:@"%@%@",YWpic,model.pic];
    [_picView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _title.text = model.title;

    _width.constant = [Utils labelWidth:[NSString stringWithFormat:@"%@米",model.selprice] font:17];
    _width2.constant = [Utils labelWidth:[NSString stringWithFormat:@"%@米",model.price] font:15];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@米",model.price]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9F9FA0"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"9F9FA0"]}];
    _oldPrice.attributedText = attrStr;
    
    _price.text = [NSString stringWithFormat:@"%@米",model.selprice];
    
    _sale.text = [NSString stringWithFormat:@"已出售：%@",model.selnum];
    _buy_btn.backgroundColor = KthemeColor;
    
}
- (IBAction)buy:(id)sender {
   
    if ([self.delegate respondsToSelector:@selector(coverDidClick:)]) {
        [self.delegate coverDidClick:_indexPath];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
