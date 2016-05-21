//
//  TabHomeRightTableCell.m
//  ygcr
//
//  Created by 黄治华(Tony Wong) on 15/06/03.
//  Copyright © 2015年 黄治华. All rights reserved.
//
//  @email 908601756@qq.com
//
//  @license The MIT License (MIT)
//

#import "TabHomeRightTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TabHomeRightTableCell ()
{
    UIImageView *_productImage;
    UILabel     *_nameLabel;
    UILabel     *_curPriceLabel;
    UILabel     *_oriPriceLabel;
    UILabel     *_reducePriceLabel;
}
@end


@implementation TabHomeRightTableCell

+ (CGFloat)height
{
    return 85;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _productImage = [UIImageView new];
    _productImage.layer.cornerRadius = 3;
    [self addSubview:_productImage];
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(8);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    _nameLabel = [UILabel new];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productImage.mas_right).with.offset(10);
        make.top.equalTo(self).with.offset(10);
    }];
    
    _curPriceLabel = [UILabel new];
    _curPriceLabel.font = [UIFont systemFontOfSize:18];
    _curPriceLabel.textColor = [UIColor blackColor];
    [self addSubview:_curPriceLabel];
    [_curPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(3);
    }];
    
    _oriPriceLabel = [UILabel new];
    [self addSubview:_oriPriceLabel];
    [_oriPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_curPriceLabel.mas_right).with.offset(20);
        make.bottom.equalTo(_curPriceLabel);
    }];
    
    _reducePriceLabel = [UILabel new];
    _reducePriceLabel.font = [UIFont systemFontOfSize:14];
    _reducePriceLabel.textColor = [UIColor blackColor];
    [self addSubview:_reducePriceLabel];
    [_reducePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_curPriceLabel.mas_bottom).with.offset(3);
    }];
    
    return self;
}

- (void)fillContentWithProduct:(YWGoods*)goods
{
    _nameLabel.text = goods.title;
    NSString *picStr = [NSString stringWithFormat:@"%@%@",YWpic,goods.pic];
    [_productImage sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _curPriceLabel.text = goods.selprice;
    _reducePriceLabel.text = [NSString stringWithFormat:@"已出售：%@",goods.selnum];
        //划线居中
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:goods.price
    attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
       NSForegroundColorAttributeName:[UIColor blackColor],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor redColor]}];
    _oriPriceLabel.attributedText = attrStr;
}

@end
