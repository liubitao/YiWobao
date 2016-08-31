//
//  YWClaim.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWClaim.h"
#import "YWUser.h"
#import "YWUserTool.h"

@interface YWClaim ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSArray* dataArray;
@property (nonatomic,strong) UITextField* number;
@property (nonatomic,strong) UITextField* name;
@property (nonatomic,strong) UITextField* phone;
@property (nonatomic,strong) UITextField* memo;
@end

@implementation YWClaim

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, self.width-100, 30)];
        title.text = @"认领详情";
        title.font = [UIFont boldSystemFontOfSize:20];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        
        UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(self.width-60, 10, 50, 30)];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cancel.tag = 1;
        [cancel addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.width-20, 240) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
        _dataArray = @[@"最小认领数",@"最大认领数",@"认领份数",@"姓名",@"电话",@"备注"];
        
        UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(0, 280, self.width, 40)];
        [submit setTitle:@"认领" forState:UIControlStateNormal];
        submit.backgroundColor = KthemeColor;
        submit.tag = 2;
        [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:submit];
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"claim"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f",[_welfare.sprice floatValue]];
            cell.detailTextLabel.backgroundColor = KthemeColor;
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f",[_welfare.topprice floatValue]];
            cell.detailTextLabel.backgroundColor = KthemeColor;
            break;
        case 2:{
            _number = [[UITextField alloc]initWithFrame:CGRectMake(tableView.width - 100, 5, 90, 30)];
            _number.textColor = KthemeColor;
            _number.keyboardType = UIKeyboardTypeNumberPad;
            _number.text = [NSString stringWithFormat:@"%.0f",[_welfare.sprice floatValue]];
            _number.borderStyle = UITextBorderStyleRoundedRect;
            _number.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_number];}
            break;
        case 3:{
            YWUser *user = [YWUserTool account];
            _name = [[UITextField alloc]initWithFrame:CGRectMake(tableView.width - 150, 5, 140, 30)];
            _name.textColor = KthemeColor;
            if (user.username) {
                _name.text = user.username;
            }else{
            _name.text = user.wxname;
            }
            _name.borderStyle = UITextBorderStyleRoundedRect;
            _name.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_name];
        }
            break;
            case 4:
        {
            YWUser *user = [YWUserTool account];
            _phone = [[UITextField alloc]initWithFrame:CGRectMake(tableView.width - 150, 5, 140, 30)];
            _phone.textColor = KthemeColor;
            _phone.textAlignment = NSTextAlignmentRight;
            _phone.keyboardType = UIKeyboardTypeNumberPad;
            _phone.borderStyle = UITextBorderStyleRoundedRect;
            _phone.text = user.phone;
            [cell.contentView addSubview:_phone];
        }
            break;
        case 5:{
            _memo = [[UITextField alloc]initWithFrame:CGRectMake(tableView.width - 150, 5, 140, 30)];
            _memo.textColor = KthemeColor;
            _memo.textAlignment = NSTextAlignmentRight;
            _memo.borderStyle = UITextBorderStyleRoundedRect;
            _memo.placeholder = @"请填写您的备注";
            [cell.contentView addSubview:_memo];
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)submit:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            if ([self.delegate respondsToSelector:@selector(hide)]) {
                [_delegate hide];
            }
            break;
        case 2:
            if ([self.delegate respondsToSelector:@selector(submit:name:phone:memo:)]) {
                [_delegate submit:_number.text name:_name.text phone:_phone.text memo:_memo.text];
            }
            break;
        default:
            break;
    }
   
}



@end
