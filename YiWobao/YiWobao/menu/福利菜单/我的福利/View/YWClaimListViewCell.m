//
//  YWClaimListViewCell.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/30.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWClaimListViewCell.h"
#import "YWWelfareView.h"

@interface YWClaimListViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet YWWelfareView *stateView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rlshuliang;

@property (weak, nonatomic) IBOutlet UILabel *rlMoney;
@property (weak, nonatomic) IBOutlet UILabel *rlTime;

@property (weak, nonatomic) IBOutlet UILabel *rlState;
@property (weak, nonatomic) IBOutlet UILabel *despLabel;


@end
@implementation YWClaimListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _clickBtn.layer.cornerRadius = 5;
    _clickBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setClaimModel:(YWclaimModel *)claimModel{
    
    _claimModel = claimModel;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    if ([claimModel.isback isEqualToString:@"1"]) {
        _stateView.color = [UIColor redColor];
        _stateLabel.text = @"回购中";
    }else {
        if ([claimModel.stsc isEqualToString:@"0"]||[claimModel.isend isEqualToString:@"1"]||[claimModel.truemoney floatValue]>=[claimModel.totalmoney floatValue]||[claimModel.endtm floatValue]<= time) {
            _stateView.color = [UIColor grayColor];
            _stateLabel.text = @"已结束";
        }else{
            _stateView.color = [UIColor colorWithHexString:@"8DDC57"];
            _stateLabel.text = @"已认领";
        }
    }
    
    _titleLabel.text = claimModel.title;
    
    _despLabel.text = claimModel.descriptions;
    
    _rlMoney.text = [NSString stringWithFormat:@"%@米",claimModel.zcmoney];

    NSTimeInterval edtime=[claimModel.zctime doubleValue];//如果不使用本地时区,因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:edtime];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];//设置本地时区
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    _rlTime.text = [dateFormatter stringFromDate: detaildate];
    
    
    if ([_claimModel.isback isEqualToString:@"1"]) {
        if ([claimModel.backstsc isEqualToString:@"0"]) {
            _clickBtn.hidden = NO;
            _rlState.text = [NSString stringWithFormat:@"回购倍率:%@",claimModel.backfit];
        }else{
            if ([claimModel.backstsc isEqualToString:@"1"]) {
                _rlState.text = @"正在回购中，请稍后...";
            }else{
                _rlState.text = [NSString stringWithFormat:@"已经回购，收入了%.2f米",claimModel.backfit.floatValue*claimModel.zcmoney.floatValue];
            }
            _clickBtn.hidden = YES;
        }
    }else{
        if ([claimModel.backstsc isEqualToString:@"0"]) {
            _clickBtn.hidden = NO;
            _rlState.text = [NSString stringWithFormat:@"回购倍率:%@",claimModel.backfit];
        }else{
            if ([claimModel.backstsc isEqualToString:@"1"]) {
                _rlState.text = @"正在回购...";
            }else{
                _rlState.text = [NSString stringWithFormat:@"已经回购，收入了%.2f米",claimModel.backfit.floatValue*claimModel.zcmoney.floatValue];
            }
            _clickBtn.hidden = YES;
        }
        _clickBtn.hidden = YES;
    }
}


- (IBAction)touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(click:claim:)]) {
        [self.delegate click:self.indexPath claim:self.claimModel];
    }
}

@end
