//
//  YwFederalCell.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/10/8.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YwFederalCell.h"
#import "YWFederalShop.h"
#import "RatingView.h"

@interface YwFederalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet RatingView *rate;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *Coupon;
@property (weak, nonatomic) IBOutlet UIImageView *couponImage;


@end

@implementation YwFederalCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(YWFederalShop *)shop;{
    [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,shop.skewm]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _title.text = shop.titlename;
    _rate.rating = 4;
    [_rate configureTextFont:[UIFont systemFontOfSize:17]];
    _adress.text = [NSString stringWithFormat:@"地址：%@",shop.address];
    _phone.text = [NSString stringWithFormat:@"电话：%@",shop.phones];
    
    _couponImage.image = [UIImage imageNamed:@"ying"];
    
    if ([Utils isNull:shop.shnote]) {
        _Coupon.hidden = YES;
    }else{
        _Coupon.text = shop.shnote;
    }
    
}

@end
