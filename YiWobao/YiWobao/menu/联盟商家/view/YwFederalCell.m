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

@property (weak, nonatomic) IBOutlet UILabel *leixing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leiWidth;


@end

@implementation YwFederalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _leixing.layer.borderColor = KthemeColor.CGColor;
    _leixing.layer.borderWidth = 1;
    _leixing.layer.cornerRadius = 3;
    _leixing.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(YWFederalShop *)shop;{
    NSUserDefaults *defait = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defait objectForKey:@"shops"];
    _leixing.text = array[[shop.shcate integerValue]-1];
   CGRect detailSize = [_leixing.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}context:nil];
    _leiWidth.constant = detailSize.size.width+10;
    [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,shop.logopic]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _title.text = shop.titlename;
    _rate.rating = 4;
    [_rate configureTextFont:[UIFont systemFontOfSize:11]];
    _adress.text = [NSString stringWithFormat:@"地址：%@",shop.address];
    _phone.text = [NSString stringWithFormat:@"电话：%@",shop.phones];

    [_leixing sizeToFit];
    if ([Utils isNull:shop.business]){
        _Coupon.hidden = YES;
    }else{
        _Coupon.text = shop.business;
    }
    
}

@end
