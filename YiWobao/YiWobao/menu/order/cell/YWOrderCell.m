//
//  YWOrderCell.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWOrderCell.h"
#import "YWOrderModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWGoods.h"
#import "Utils.h"

@interface YWOrderCell ()

@property (nonatomic,weak) UILabel *time_label;
@property (nonatomic,weak) UILabel *paystatus;
@property (nonatomic,weak) UIImageView *picView;
@property (nonatomic,weak) UITextView *title;
@property (nonatomic,weak) UILabel *price;
@property (nonatomic,weak) UILabel *selprice;
@property (nonatomic,weak) UIButton *cancel;
@property (nonatomic,weak) UIButton *pay;
@property (nonatomic,weak) UILabel *number;
@property (nonatomic,weak) UIButton *share_btn;
@property (nonatomic,weak) UILabel *total;

@property (nonatomic,assign) BOOL change;

@end

@implementation YWOrderCell

// 手写代码构造
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子视图
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews{
    //时间
    UILabel *time_label = [[UILabel alloc]initWithFrame:CGRectMake(20,5, 200, 15)];
    time_label.font = [UIFont systemFontOfSize:13];
    time_label.textColor = [UIColor colorWithHexString:@"221814"];
    [self.contentView addSubview:time_label];
    _time_label = time_label;
    
    //支付状态
    UILabel *paystatus_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-120, 5, 100, 15)];
    paystatus_label.textAlignment = NSTextAlignmentRight;
    paystatus_label.font = [UIFont systemFontOfSize:14];
    paystatus_label.textColor = [UIColor colorWithHexString:@"221814"];
    [self.contentView addSubview:paystatus_label];
    _paystatus = paystatus_label;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth, 70)];
    view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    [self.contentView addSubview:view];
    
    //商品图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 66, 60)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];
    _picView = imageView;
    
    //商品名称
    UITextView *title_label = [[UITextView alloc]initWithFrame:CGRectMake(97, 9, kScreenWidth-100-110, 55)];
    title_label.scrollEnabled = NO;
    title_label.editable = NO;
    title_label.backgroundColor = [UIColor clearColor];
    title_label.font = [UIFont systemFontOfSize:13];
    title_label.textColor = [UIColor colorWithHexString:@"221814"];
    [view addSubview:title_label];
    _title = title_label;
    
    //原始价格
    UILabel *price_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-105, 33, 85, 15)];
    price_label.textAlignment = NSTextAlignmentRight;
    price_label.font = [UIFont systemFontOfSize:13];
    [view addSubview:price_label];
    _price = price_label;
    
    //折后价格
    UILabel *selprice_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-105, 12, 85, 15)];
    selprice_label.textAlignment = NSTextAlignmentRight;
    selprice_label.font = [UIFont systemFontOfSize:13];
    [view addSubview:selprice_label];
    _selprice = selprice_label;
    
    //数量
    UILabel *number_label = [[UILabel alloc]initWithFrame:CGRectZero];
    number_label.textAlignment = NSTextAlignmentRight;
    number_label.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:number_label];
    _number = number_label;
    
    //总价
    UILabel *total_label = [[UILabel alloc]initWithFrame:CGRectZero];
    total_label.textAlignment = NSTextAlignmentRight;
    total_label.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:total_label];
    _total = total_label;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 26, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"717071" withAlpha:0.5];
    [self.contentView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 95, kScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"717071" withAlpha:0.5];
    [self.contentView addSubview:line2];
    
    if ([self.reuseIdentifier isEqualToString:@"orderCell1"]) {
        [self createTilte1:@"取消订单" title2:@"分享代付码"];
    }else if ([self.reuseIdentifier isEqualToString:@"orderCell3"]){
        [self createTilte1:@"拒绝代付" title2:@"确认代付"];
    }

}

- (void)createTilte1:(NSString *)str1 title2:(NSString *)str2{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 127, kScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"717071" withAlpha:0.5];
    [self.contentView addSubview:line];
    //取消
    UIButton *cancel_button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-172, 135,60, 20)];
    cancel_button.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancel_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancel_button.layer.borderColor = [[UIColor blackColor]CGColor];
    cancel_button.layer.borderWidth = 1;
    cancel_button.layer.cornerRadius = 5;
    cancel_button.layer.masksToBounds = YES;
    [cancel_button setTitle:str1 forState:UIControlStateNormal];
    [self.contentView addSubview:cancel_button];
    [cancel_button addTarget:self action:@selector(hanleOrder:) forControlEvents:UIControlEventTouchUpInside];
    [cancel_button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.5 alpha:0.3]] forState:UIControlStateHighlighted];
    cancel_button.tag = 1;
    _cancel = cancel_button;
    
    //分享代付码
    UIButton *share_button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-90, 135, 70, 20)];
    share_button.titleLabel.font = [UIFont systemFontOfSize:13];
    [share_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    share_button.layer.borderColor = [[UIColor blackColor]CGColor];
    share_button.layer.borderWidth = 1;
    share_button.layer.cornerRadius = 5;
    share_button.layer.masksToBounds = YES;
    [share_button setTitle:str2 forState:UIControlStateNormal];
    [share_button addTarget:self action:@selector(hanleOrder:) forControlEvents:UIControlEventTouchUpInside];
    [share_button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.5 alpha:0.3]] forState:UIControlStateHighlighted];
    share_button.tag = 2;
    [self.contentView addSubview:share_button];
    _share_btn = share_button;
}


- (void)hanleOrder:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(changeState:tag:type:)]) {
        [self.delegate changeState:_indexPath tag:sender.tag type:_type];
    }
}

- (void)setModel:(YWOrderModel *)model{
    //时间戳转化
    NSTimeInterval time=[model.regtime doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _time_label.text =[dateFormatter stringFromDate: detaildate];
    
    switch ([model.paystatus intValue]) {
        case 0:
            if ([model.paykind intValue] == 0) {
                _paystatus.text = @"已拒绝";
            }else{
            _paystatus.text = @"待支付";
            }
            break;
        case 1:
            _paystatus.text = @"已支付";
            break;
        case 2:
            _paystatus.text = @"已取消";
            break;
        default:
            break;
    }
    NSString *pic_str = [NSString stringWithFormat:@"%@%@",YWpic,model.goods.pic];
    [_picView sd_setImageWithURL:[NSURL URLWithString:pic_str] placeholderImage:[UIImage imageNamed:@"default－portrait"]];
    _title.text = model.goods.title;
    _selprice.text = [NSString stringWithFormat:@"%@米",model.goods.selprice];
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@米",model.goods.price]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:13],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"717071"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"717071"]}];
    _price.attributedText = attrStr;
    
    
    NSString *str1 = [NSString stringWithFormat:@"数量：%@",model.num];
    NSString *str2 = [NSString stringWithFormat:@"总价：%@米",model.pmoney];
    CGFloat width = [Utils labelWidth:str2 font:13];
    _total.frame = CGRectMake(kScreenWidth-width-20, 107, width, 15);
    _number.frame = CGRectMake(0, 107, kScreenWidth-_total.width-35-20, 15);
    _number.text = str1;
    _total.text = str2;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
