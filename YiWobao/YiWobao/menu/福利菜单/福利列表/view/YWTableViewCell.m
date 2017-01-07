//
//  YWTableViewCell.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/19.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWWelfareView.h"
@interface YWTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progress;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *descrpi;
@property (weak, nonatomic) IBOutlet UIImageView *imag1;
@property (weak, nonatomic) IBOutlet UIImageView *imag2;
@property (weak, nonatomic) IBOutlet UIImageView *imag3;
@property (weak, nonatomic) IBOutlet UIImageView *imag4;
@property (weak, nonatomic) IBOutlet UILabel *plan;
@property (weak, nonatomic) IBOutlet UIView *totalPlan;
@property (weak, nonatomic) IBOutlet UILabel *sta;
@property (weak, nonatomic) IBOutlet YWWelfareView *state;
@property (weak, nonatomic) IBOutlet UIView *currentProgress;

@end
@implementation YWTableViewCell

- (void)awakeFromNib {
     [super awakeFromNib];
    _totalPlan.layer.cornerRadius = 5;
    _totalPlan.layer.masksToBounds = YES;
    
    _currentProgress.layer.cornerRadius = 5;
    _currentProgress.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(YWWelfare *)welfare{
    self.title.text = [NSString stringWithFormat:@"             %@",welfare.title];
    self.descrpi.text = welfare.descriptions;
    [self.imag1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,welfare.img1]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.imag2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,welfare.img2]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.imag3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,welfare.img3]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.imag4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,welfare.img4]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
 
    self.plan.text = [NSString stringWithFormat:@"%.2f%%",[welfare.truemoney floatValue]/[welfare.totalmoney floatValue]*100];
    CGFloat width = kScreenWidth-60;
    self.progress.constant = MIN(width *[welfare.truemoney floatValue]/[welfare.totalmoney floatValue], width);
    

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time=[dat timeIntervalSince1970];
    
    if ([welfare.isback isEqualToString:@"1"]) {
        _state.color = [UIColor redColor];
        _sta.text = @"回购中";
    }else {
        if ([welfare.stsc isEqualToString:@"0"]||[welfare.isend isEqualToString:@"1"]||[welfare.truemoney floatValue]>=[welfare.totalmoney floatValue]||[welfare.endtm floatValue]<= time) {
            _state.color = [UIColor grayColor];
            _sta.text = @"已结束";
        }else{
            float i = [welfare.endtm floatValue] - time;
            _state.color = [UIColor colorWithHexString:@"8DDC57"];
            _sta.text = [NSString stringWithFormat:@"%.0f天",i/60/60/24+1];
        }
    }
   
}
@end
