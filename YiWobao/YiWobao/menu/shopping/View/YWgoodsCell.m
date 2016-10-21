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
@property (weak, nonatomic) IBOutlet UILabel *sale;
@property (weak, nonatomic) IBOutlet UIImageView *free;


@end

@implementation YWgoodsCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setCellModel:(YWGoods *)model{
  
    if ([model.gstc isEqualToString:@"1"]) {
        _free.hidden = NO;
    }else if ([model.isfree isEqualToString:@"1"]){
        _free.hidden = NO;
    }else{
        _free.hidden = YES;
    }

    
    NSString *picStr = [NSString stringWithFormat:@"%@%@",YWpic,model.pic];
    [_picView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _title.text = model.title;

    _width.constant = [Utils labelWidth:[NSString stringWithFormat:@"%@米",model.selprice] font:16 height:20];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@米",model.price]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"555555"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"555555"]}];
    _oldPrice.attributedText = attrStr;
    
    _price.text = [NSString stringWithFormat:@"¥%@",model.selprice];
    
    _sale.text = [NSString stringWithFormat:@"已售：%@件",model.selnum];

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
