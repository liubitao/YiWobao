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

@interface YWgoodsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *sale;


@end

@implementation YWgoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(YWGoods *)model{
    NSString *picStr = [NSString stringWithFormat:@"%@%@",YWpic,model.pic];
    [_picView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _title.text = model.title;
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:model.selprice
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
       NSForegroundColorAttributeName:[UIColor blackColor],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor redColor]}];
    _oldPrice.attributedText = attrStr;
    
    _Price.text = model.selprice;
    
    _sale.text = [NSString stringWithFormat:@"已出售：%@",model.selnum];
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
