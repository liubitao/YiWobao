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

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) UILabel *Price;
@property (strong, nonatomic)  UILabel *oldPrice;
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
    
    
    
    _Price = [[UILabel alloc]initWithFrame:CGRectMake(129, 60, [Utils labelWidth:[NSString stringWithFormat:@"%@米",model.selprice] font:16], 20)];
    _oldPrice = [[UILabel alloc]initWithFrame:CGRectMake(129+_Price.width+10 , 60, [Utils labelWidth:[NSString stringWithFormat:@"%@米",model.price] font:14], 20)];
    _Price.textColor = KthemeColor;
    _Price.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_Price];
    [self.contentView addSubview:_oldPrice];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@米",model.price]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9F9FA0"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"9F9FA0"]}];
    _oldPrice.attributedText = attrStr;
    
    _Price.text = [NSString stringWithFormat:@"%@米",model.selprice];
    
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
