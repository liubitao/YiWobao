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
    UILabel *time_label = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 200, 20)];
    time_label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:time_label];
    _time_label = time_label;
    
    //支付状态
    UILabel *paystatus_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-110, 10, 100, 20)];
    paystatus_label.textAlignment = NSTextAlignmentRight;
    paystatus_label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:paystatus_label];
    _paystatus = paystatus_label;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 60)];
    view.backgroundColor = KviewColor;
    [self.contentView addSubview:view];
    
    //商品图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60, 60)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    _picView = imageView;
    
    //商品名称
    UITextView *title_label = [[UITextView alloc]initWithFrame:CGRectMake(90, 0, 150, 60)];
    title_label.scrollEnabled = NO;
    title_label.backgroundColor = [UIColor clearColor];
    title_label.font = [UIFont systemFontOfSize:15];
    [view addSubview:title_label];
    _title = title_label;
    
    //原始价格
    UILabel *price_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 0, 80, 30)];
    price_label.textAlignment = NSTextAlignmentRight;
    price_label.font = [UIFont systemFontOfSize:20];
    [view addSubview:price_label];
    _price = price_label;
    
    //折后价格
    UILabel *selprice_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 30, 80, 30)];
    selprice_label.textAlignment = NSTextAlignmentRight;
    [view addSubview:selprice_label];
    _selprice = selprice_label;
    
    //数量及总价
    UILabel *number_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, kScreenWidth-20, 20)];
    number_label.textAlignment = NSTextAlignmentRight;
    number_label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:number_label];
    _number = number_label;
    
    //取消
    UIButton *cancel_button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-170, 110, 110, 30)];
    cancel_button.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancel_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel_button setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.contentView addSubview:cancel_button];
    _cancel = cancel_button;
  
}

- (void)setModel:(YWOrderModel *)model{
    //时间戳转化
    //时间戳
    
    NSTimeInterval time=[model.regtime doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _time_label.text =[dateFormatter stringFromDate: detaildate];
    
    
    switch ([model.paystatus intValue]) {
        case 0:
            _paystatus.text = @"待支付";
            break;
        case 1:
            _paystatus.text = @"已支付";
            break;
        case 2:
            _paystatus.text = @"取消订单";
            break;
        default:
            break;
    }
    NSString *pic_str = [NSString stringWithFormat:@"%@%@",YWpic,model.goods.pic];
    [_picView sd_setImageWithURL:[NSURL URLWithString:pic_str] placeholderImage:[UIImage imageNamed:@"default－portrait"]];
    _title.text = model.goods.title;
    _price.text = model.goods.price;
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:model.goods.selprice
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18.f],
       NSForegroundColorAttributeName:[UIColor blackColor],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor redColor]}];
    _selprice.attributedText = attrStr;
    
    _number.text = [NSString stringWithFormat:@"数量：%@   总价：%@",model.num,model.pmoney];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
