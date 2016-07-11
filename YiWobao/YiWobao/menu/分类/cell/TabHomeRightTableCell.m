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
    return 80;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger cellWidth = kScreenWidth-90-10;
    _productImage = [UIImageView new];
    _productImage.layer.cornerRadius = 3;
    [self.contentView addSubview:_productImage];
    _productImage.frame = CGRectMake(5, 5, 76, 69);
    
    _curPriceLabel = [UILabel new];
    _curPriceLabel.font = [UIFont systemFontOfSize:15];
    _curPriceLabel.textColor = [UIColor blackColor];
    _curPriceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_curPriceLabel];
    _curPriceLabel.frame = CGRectMake(cellWidth-90, 15, 85, 20);
  
    _nameLabel = [UILabel new];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.numberOfLines = 2;
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.frame = CGRectMake(86,10, cellWidth-76 - 90, 40);
 
    _oriPriceLabel = [UILabel new];
    [self.contentView addSubview:_oriPriceLabel];
    _oriPriceLabel.textAlignment = NSTextAlignmentRight;
    _oriPriceLabel.frame = CGRectMake(cellWidth-90,35, 85, 20);
    
    _reducePriceLabel = [UILabel new];
    _reducePriceLabel.font = [UIFont systemFontOfSize:13];
    _reducePriceLabel.textColor = [UIColor blackColor];
    [self addSubview:_reducePriceLabel];
    _reducePriceLabel.frame = CGRectMake(86,60, 200, 20);
 
    
    return self;
}

- (void)fillContentWithProduct:(YWGoods*)goods
{
    _nameLabel.text = goods.title;
    NSString *picStr = [NSString stringWithFormat:@"%@%@",YWpic,goods.pic];
    [_productImage sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _curPriceLabel.text = [NSString stringWithFormat:@"%@米",goods.selprice];
    _curPriceLabel.textColor = KthemeColor;
    _reducePriceLabel.text = [NSString stringWithFormat:@"已出售：%@ 件",goods.selnum];
        //划线居中
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@米",goods.price]
    attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
       NSForegroundColorAttributeName:[UIColor blackColor],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
    _oriPriceLabel.attributedText = attrStr;
}

@end
