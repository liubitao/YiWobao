//
//  YWClaimListViewCell.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/30.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWClaimListViewCell.h"

@interface YWClaimListViewCell (){
    NSString *ID;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *time_y;



@end
@implementation YWClaimListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YWclaimModel *)claimModel{
    // 视图内容布局
    CGRect detailSize = [_title.text boundingRectWithSize:CGSizeMake(kScreenWidth-130, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}context:nil];
    if (detailSize.size.height<30) {
         _title_height.constant = 30;
    }else{
    _title_height.constant = detailSize.size.height;
    }
    _time_y.constant = _title_height.constant+10-30;
    
    //时间戳转化
    NSTimeInterval time=[claimModel.zctime doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _time.text =[dateFormatter stringFromDate: detaildate];
    
    _share.text = claimModel.zcmoney;
    
    if ([claimModel.backstsc isEqualToString:@"0"]) {
        _apply.tag = 1;
        _state.text = @"正常持有";
        [_apply setTitle:@"申请回购" forState:UIControlStateNormal];
    }else if ([claimModel.backstsc isEqualToString:@"1"]){
        _apply.tag = 0;
        _state.text = @"正在申请回购";
        [_apply setTitle:@"正在申请回购" forState:UIControlStateNormal];
        [_apply setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        _apply.tag = 0;
        _state.text = @"已经回购";
        [_apply setTitle:@"已经回购" forState:UIControlStateNormal];
        [_apply setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    if ([_isback isEqualToString:@"0"]) {
        _apply.tag = 0;
        [_apply setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    ID = claimModel.ID;
    
}

- (void)buy_back:(Buy_back)buy_back{
    self.buy_back = buy_back;
}

- (IBAction)touch:(id)sender {
    if (_apply.tag == 1) {
    [UIAlertController showAlertViewWithTitle:nil Message:@"确定申请回购？" BtnTitles:@[@"取消",@"确定"] ClickBtn:^(NSInteger index) {
        if (index == 1) {
            
                if (self.buy_back !=nil ) {
                    self.buy_back(ID);
                
            }
        }
    }];
    }
    
}

@end
