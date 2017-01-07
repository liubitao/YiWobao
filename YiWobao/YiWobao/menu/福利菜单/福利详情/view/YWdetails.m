//
//  YWdetails.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/24.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWdetails.h"
#import "Utils.h"

@interface YWdetails ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jindu;
@property (weak, nonatomic) IBOutlet UILabel *jinduLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rzjigou;
@property (weak, nonatomic) IBOutlet UILabel *minrl;
@property (weak, nonatomic) IBOutlet UILabel *maxrl;
@property (weak, nonatomic) IBOutlet UILabel *rlyq;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UIView *currentjindu;



@end
@implementation YWdetails


- (void)setModel:(YWWelfare *)welfare{
    _totalView.layer.cornerRadius = 5;
    _totalView.layer.masksToBounds = YES;
    
    _currentjindu.layer.cornerRadius = 5;
    _currentjindu.layer.masksToBounds = YES;
    
    // 视图内容布局
    // 视图内容布局
    CGFloat width = kScreenWidth-40;
    _jindu.constant = MIN(width *[welfare.truemoney floatValue]/[welfare.totalmoney floatValue], width);
    
    
    _jinduLabel.text = [NSString stringWithFormat:@"%.2f%%",[welfare.truemoney floatValue]/[welfare.totalmoney floatValue]*100];
    
    _titleLabel.text = welfare.title;
    
    _minrl.text = [NSString stringWithFormat:@"%@份",welfare.sprice];
    
    _maxrl.text =  [NSString stringWithFormat:@"%@份",welfare.topprice];
    
    if ([welfare.canget isEqualToString:@"0"]) {
        _rlyq.text = @"不限制";
        
    }else if ([welfare.canget isEqualToString:@"1"]){
        _rlyq.text = @"众创领袖以上才能购买";
    }else if([welfare.canget isEqualToString:@"2"]){
        _rlyq.text = @"事业董事才能购买";
    }
    
}



@end
