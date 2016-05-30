//
//  YWBuyViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/20.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWBuyViewController.h"
#import "YWGoods.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWAddressController.h"
#import "YWUser.h"
#import "YWHttptool.h"
#import "YWUserTool.h"
#import "Utils.h"
#import "YWAddressModel.h"
#import "YWBuyGoods.h"
#import "CYPasswordView.h"
#import "MBProgressHUD+MJ.h"
#import "RegisterController.h"


#define kRequestTime 3.0f
#define kDelay 1.0f

@interface YWBuyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITableView *_tableView;
    UIView *_buttomView;
    UILabel *_price;
}


@property (nonatomic,strong) UITextField *remarks_text;
@property (nonatomic,strong) UIButton *last_btn;
@property (nonatomic,strong) UITextField *num;

@property (nonatomic,strong) YWBuyGoods *buyGoods;

@property (nonatomic,strong) YWAddressModel *addressModel;

@property (nonatomic, strong) CYPasswordView *passwordView;

@end

@implementation YWBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买详情";
    self.view.backgroundColor = KviewColor;
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gesture];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //下面的选项
    _buttomView =[UIView new];
    _buttomView.backgroundColor= [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:_buttomView];
    [_buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 60));
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    _price=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 170, 60)];
    _price.textColor=[UIColor whiteColor];
    _price.font=[UIFont systemFontOfSize:18];
    _price.text=[NSString stringWithFormat:@"实付款：%@",_goods.selprice];
    [_buttomView addSubview:_price];
    
    UIButton *addCart = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-140, 0, 140, 60)];
    [addCart setTitle:@"提交订单" forState:UIControlStateNormal];
    [addCart addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [addCart.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [addCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCart setBackgroundColor:[UIColor colorWithRed:255/255.0 green:100/255.0 blue:98/255.0 alpha:1]];
    [_buttomView addSubview:addCart];

    /** 注册取消按钮点击的通知 */
    [CYNotificationCenter addObserver:self selector:@selector(cancel) name:CYPasswordViewCancleButtonClickNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];
}

- (void)cancel{
     [MBProgressHUD showSuccess:@"关闭密码框"];
}

- (void)forgetPWD{
    [MBProgressHUD showSuccess:@"忘记密码"];
    [self.passwordView hide];
    RegisterController *VC = [[RegisterController alloc]init];
    VC.title = @"修改支付密码";
    VC.type_r = @"3";
    [self.navigationController pushViewController:VC animated:YES];
}


//提交订单
- (void)submitClick{
    if ([Utils isNull:_addressModel]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请输入您的收货地址" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    __weak YWBuyViewController *weakSelf = self;
    self.passwordView = [[CYPasswordView alloc] init];
    self.passwordView.title = @"输入交易密码";
    self.passwordView.loadingText = @"提交中...";
    [self.passwordView showInView:self.view.window];
    self.passwordView.finish = ^(NSString *password) {
        [weakSelf.passwordView hideKeyboard];
        [weakSelf.passwordView startLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kRequestTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YWUser *user = [YWUserTool account];
            NSMutableDictionary *paramters = [Utils paramter:Goods_order ID:user.ID];
            NSMutableDictionary *buyarr = [NSMutableDictionary dictionary];
            buyarr[@"gid"] = weakSelf.goods.ID;
            buyarr[@"gnum"] = weakSelf.num.text;
            buyarr[@"aid"] = weakSelf.addressModel.ID;
            buyarr[@"onum"] = weakSelf.buyGoods.buyGoodsON;
            buyarr[@"pkd"] = [NSString stringWithFormat:@"%ld",weakSelf.last_btn.tag];
            buyarr[@"pwd"] = [password MD5Digest];
            buyarr[@"omeno"] = weakSelf.remarks_text.text;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:buyarr options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            paramters[@"buyarr"] = str;
            [YWHttptool Post:YWGoodsOrder parameters:paramters success:^(id responseObject) {
                NSInteger isError = [responseObject[@"isError"] integerValue];
                if (!isError) {
                    [MBProgressHUD showSuccess:@"支付成功"];
                    [weakSelf.passwordView requestComplete:YES message:@"支付成功"];
                    [weakSelf.passwordView stopLoading];
                   
                        [weakSelf.passwordView hide];
                   
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [MBProgressHUD showError:responseObject[@"errorMessage"]];
                    [weakSelf.passwordView requestComplete:NO message:responseObject[@"errorMessage"]];
                    [weakSelf.passwordView stopLoading];
                        [weakSelf.passwordView hide];
                }
            } failure:^(NSError *error) {
                
            }];
        });
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyCell"];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if ([Utils isNull:_addressModel]) {
            UIImageView * addressBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            addressBg.image=[UIImage imageNamed:@"address_info_bg"];
            [cell.contentView addSubview:addressBg];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-20, 30)];
            label.text = @"您还没保存收货地址，请输入";
            label.textColor = [UIColor redColor];
            [cell.contentView addSubview:label];
            
            UIImageView * moreImg =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-30, 0, 30, 50)];
            moreImg.contentMode =  UIViewContentModeCenter;
            moreImg.image=[UIImage imageNamed:@"address_more_icon"];
            [cell.contentView addSubview:moreImg];
            
        }else{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        UIImageView * addressBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headerView.width, headerView.height)];
        addressBg.image=[UIImage imageNamed:@"address_info_bg"];
        [headerView addSubview:addressBg];
        
        UIImageView * nameImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
        nameImg.contentMode =  UIViewContentModeCenter;
        nameImg.image=[UIImage imageNamed:@"address_name_icon"];
        [addressBg addSubview:nameImg];
        
        UILabel * name =[[UILabel alloc]initWithFrame:CGRectMake(30, 20, 100, 20)];
        name.text = _addressModel.pickname;
        [addressBg addSubview:name];
        
        UIImageView * phoneImg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-150, 20, 20, 20)];
        phoneImg.contentMode =  UIViewContentModeCenter;
        phoneImg.image=[UIImage imageNamed:@"address_phone_icon"];
        [addressBg addSubview:phoneImg];
        
        UILabel * phone =[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-125, 20, 120, 20)];
        phone.text = _addressModel.pickphone;
        [addressBg addSubview:phone];
        
        UILabel * address = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, headerView.width-30, 40)];
        address.font=[UIFont systemFontOfSize:14];
        address.textColor=[UIColor darkGrayColor];
        address.numberOfLines =2;
        address.text = [NSString stringWithFormat:@"%@%@%@%@",_addressModel.addr1,_addressModel.addr2,_addressModel.addr3,_addressModel.addr4];
        [addressBg addSubview:address];
        
        UIImageView * moreImg =[[UIImageView alloc]initWithFrame:CGRectMake(headerView.width-30, 0, 30, headerView.height)];
        moreImg.contentMode =  UIViewContentModeCenter;
        moreImg.image=[UIImage imageNamed:@"address_more_icon"];
        [addressBg addSubview:moreImg];
        
            [cell.contentView addSubview:headerView];}
    }else if (indexPath.section == 1 && indexPath.row == 0){
        //订单号
        UILabel *time_label = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 220, 20)];
        time_label.font = [UIFont systemFontOfSize:12];
        time_label.text = [NSString stringWithFormat:@"订单编号:%@",_buyGoods.buyGoodsON];
        [cell.contentView addSubview:time_label];
        
        //商品编号
        UILabel *paystatus_label = [[UILabel alloc]initWithFrame:CGRectMake(230, 0, kScreenWidth-250, 20)];
        paystatus_label.textAlignment = NSTextAlignmentRight;
        paystatus_label.font = [UIFont systemFontOfSize:12];
        paystatus_label.text = [NSString stringWithFormat:@"商品编号:%@",_buyGoods.buyGoodsBH];
        [cell.contentView addSubview:paystatus_label];
        
        UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 60, 60)];
        NSString *picStr = [NSString stringWithFormat:@"%@%@",YWpic,_goods.pic];
        [picView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        picView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:picView];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 19, kScreenWidth, 1)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [cell.contentView addSubview:view];
        
        //商品名称
        UITextView *title_label = [[UITextView alloc]initWithFrame:CGRectMake(80, 20, 150, 60)];
        title_label.scrollEnabled = NO;
        title_label.editable = NO;
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:title_label];
        title_label.text = _goods.title;
        
        //原始价格
        UILabel *price_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 20, 80, 30)];
        price_label.textAlignment = NSTextAlignmentRight;
        price_label.font = [UIFont systemFontOfSize:20];
        [cell.contentView addSubview:price_label];
        price_label.text = _goods.selprice;
        
        
        //折后价格
        UILabel *selprice_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 50, 80, 30)];
        selprice_label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:selprice_label];
        NSAttributedString *attrStr =
        [[NSAttributedString alloc]initWithString:_goods.price
                                       attributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18.f],
           NSForegroundColorAttributeName:[UIColor blackColor],
           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
           NSStrikethroughColorAttributeName:[UIColor redColor]}];
        selprice_label.attributedText = attrStr;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        cell.textLabel.text = @"购买数量";
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 120,7.5, 90, 25)];
        view.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:view];
        
        UIButton *subtract_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [subtract_btn setBackgroundImage:[UIImage imageNamed:@"syncart_less_btn_enable"] forState:UIControlStateNormal];
        [subtract_btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        subtract_btn.tag = 1;
        [view addSubview:subtract_btn];
        
        _num = [[UITextField alloc]initWithFrame:CGRectMake(25, 0, 40, 25)];
        _num.borderStyle = UITextBorderStyleNone;
        _num.background = [UIImage imageNamed:@"syncart_middle_btn_enable"];
        _num.text = @"1";
        _num.keyboardType = UIKeyboardTypeNumberPad;
        _num.delegate = self;
        _num.textAlignment = NSTextAlignmentCenter;
        [view addSubview:_num];
        
        UIButton *add_btn = [[UIButton alloc]initWithFrame:CGRectMake(65, 0, 25, 25)];
        [add_btn setBackgroundImage:[UIImage imageNamed:@"syncart_more_btn_enable"] forState:UIControlStateNormal];
        add_btn.tag = 2;
        [add_btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:add_btn];
        [cell.contentView addSubview:view];
        
    }else if (indexPath.section ==1 && indexPath.row == 2){
        cell.textLabel.text = @"备注";
        _remarks_text = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenWidth-120, 30)];
        _remarks_text.placeholder = @"选填：对本次交易的说明以及对卖家的留言。";
        _remarks_text.textColor = [UIColor redColor];
        _remarks_text.borderStyle = UITextBorderStyleNone;
        _remarks_text.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:_remarks_text];
    }else if (indexPath.section ==1 && indexPath.row == 3){
        cell.textLabel.text = @"支付方式";
        
        UIButton *pay_btn1 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-200, 5, 80, 30)];
        UIButton *pay_btn2 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-100, 5, 80, 30)];

        [pay_btn1 setTitle:@"蚁米支付" forState:UIControlStateNormal];
        [pay_btn2 setTitle:@"推荐人代付" forState:UIControlStateNormal];
        [pay_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        pay_btn1.titleLabel.font = [UIFont systemFontOfSize:16];
        [pay_btn1 setBackgroundImage:[UIImage imageWithColor:KviewColor] forState:UIControlStateHighlighted];
        [pay_btn2 setBackgroundImage:[UIImage imageWithColor:KviewColor] forState:UIControlStateHighlighted]; 
        
        [pay_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        pay_btn2.titleLabel.font = [UIFont systemFontOfSize:16];
        pay_btn1.tag = 0;
        pay_btn2.tag = 2;
        pay_btn1.layer.borderWidth = 1;
        pay_btn1.layer.borderColor = [[UIColor redColor]CGColor];
        pay_btn2.layer.borderWidth = 1;
        pay_btn2.layer.borderColor = [[UIColor blackColor]CGColor];
        [pay_btn1 addTarget:self action:@selector(payWay:) forControlEvents:UIControlEventTouchUpInside];
        [pay_btn2 addTarget:self action:@selector(payWay:) forControlEvents:UIControlEventTouchUpInside];
        _last_btn = pay_btn1;
        [cell.contentView addSubview:pay_btn1];
        [cell.contentView addSubview:pay_btn2];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([Utils isNull:_addressModel]) {
            return 50;
        }
        return 100;
    }
    else if (indexPath.section ==1 && indexPath.row == 0){
        return 80;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        YWAddressController *addressVC = [[YWAddressController alloc]init];
        [self.navigationController pushViewController:addressVC  animated:YES];
    }
}

- (void)change:(UIButton *)sender{
    if (sender.tag == 1) {
        if ([_num.text isEqualToString:@"1"]) {
            return;
        }
        _num.text = [NSString stringWithFormat:@"%d",[_num.text intValue]-1];
    }else{
        _num.text = [NSString stringWithFormat:@"%d",[_num.text intValue]+1];
    }
    int number = [_num.text intValue];
    _price.text = [NSString stringWithFormat:@"实付款：%.2f",[_goods.selprice floatValue]*number];
}

- (void)payWay:(UIButton *)sender{
    if (_last_btn.tag == sender.tag) {
        return;
    }
    sender.layer.borderColor = [[UIColor redColor]CGColor];
    _last_btn.layer.borderColor = [[UIColor blackColor]CGColor];
    _last_btn = sender;
}



//确定这个手势是否可以实现
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //判断这个账号和密码控件中是否都是第一响应者
    if (![_num isFirstResponder]&&![_remarks_text isFirstResponder]) {
        //都不是第一响应者的时候
        return NO;
    }
    return YES;
}
//隐藏键盘栏
- (void)hidenKeyboard
{
    [_num resignFirstResponder];
    [_remarks_text resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    int number = [_num.text intValue];
    _price.text = [NSString stringWithFormat:@"实付款：%.2f",[_goods.selprice floatValue]*number];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *parameters = [Utils paramter:Goods_buy ID:user.ID];
    parameters[@"gid"] = [[_goods.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    parameters[@"gnum"] = [[@"1" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool Post:YWGoodBuy parameters:parameters success:^(id responseObject) {
        YWLog(@"%@",responseObject);
        if (![Utils isNull:responseObject[@"result"]]) {
            _buyGoods = [YWBuyGoods yw_objectWithKeyValues:responseObject[@"result"]];
            if ([Utils isNull:responseObject[@"result"][@"buyAddr"]]) {
                _addressModel = nil;
            }else{
            _addressModel = _buyGoods.addressModel;
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
