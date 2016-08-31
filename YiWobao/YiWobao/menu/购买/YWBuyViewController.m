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
#import "MBProgressHUD+MJ.h"
#import "RegisterController.h"


#define kRequestTime 3.0f
#define kDelay 1.0f

@interface YWBuyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_buttomView;
    UILabel *_price;
    CGRect _detailSize;
}


@property (nonatomic,strong) UITextField *remarks_text;
@property (nonatomic,strong) UIButton *last_btn;
@property (nonatomic,strong) UITextField *num;

@property (nonatomic,strong) YWBuyGoods *buyGoods;

@property (nonatomic,strong) YWAddressModel *addressModel;


@end

@implementation YWBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"E5E6E6"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64-50) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    //下面的选项
    _buttomView =[UIView new];
    _buttomView.backgroundColor= [UIColor colorWithHexString:@"E5E6E6"];
    [self.view addSubview:_buttomView];
    [_buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 50));
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    _price=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-110, 50)];
    _price.font=[UIFont systemFontOfSize:15];
    _price.text=[NSString stringWithFormat:@"共计1件商品 合计：%@米",_goods.selprice];
    _price.textAlignment = NSTextAlignmentCenter;
    [_buttomView addSubview:_price];
    
    UIButton *addCart = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-110, 0, 110, 50)];
    addCart.backgroundColor = KthemeColor;
    [addCart setTitle:@"提交订单" forState:UIControlStateNormal];
    [addCart addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [addCart.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [addCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttomView addSubview:addCart];
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showMessage:@"正在支付" toView:self.view];
        YWUser *user = [YWUserTool account];
                    NSMutableDictionary *paramters = [Utils paramter:Goods_order ID:user.ID];
                    NSMutableDictionary *buyarr = [NSMutableDictionary dictionary];
                    buyarr[@"gid"] = self.goods.ID;
                    buyarr[@"gnum"] = self.num.text;
                    buyarr[@"aid"] = self.addressModel.ID;
                    buyarr[@"onum"] = self.buyGoods.buyGoodsON;
                    buyarr[@"pkd"] = [NSString stringWithFormat:@"%ld",self.last_btn.tag];
                    buyarr[@"pwd"] = [alertController.textFields[0].text MD5Digest];
                    buyarr[@"omeno"] = self.remarks_text.text;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:buyarr options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    paramters[@"buyarr"] = str;
                    [YWHttptool Post:YWGoodsOrder parameters:paramters success:^(id responseObject) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        NSInteger isError = [responseObject[@"isError"] integerValue];
                        if (!isError) {
                            [UIAlertController showAlertViewWithTitle:nil Message:@"支付成功" BtnTitles:@[@"知道了"] ClickBtn:nil];
                        }
                        else{
                            [MBProgressHUD showError:responseObject[@"errorMessage"]];
                        }
                    } failure:^(NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [MBProgressHUD showError:@"请检查网络"];
                    }];

    }]];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入支付密码";
        textField.secureTextEntry = YES;
        textField.font = [UIFont systemFontOfSize:20];
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alertController.actions[0] setValue:[UIColor redColor] forKeyPath:@"_titleTextColor"];
    
    [self presentViewController:alertController animated:true completion:nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
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
        NSString *text = [NSString stringWithFormat:@"%@%@%@%@",_addressModel.addr1,_addressModel.addr2,_addressModel.addr3,_addressModel.addr4];
        NSString *text2 = [NSString stringWithFormat:@"%@   %@",text,_addressModel.pickphone];
        _detailSize = [text2 boundingRectWithSize:CGSizeMake(self.view.width-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}context:nil];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.view.width-30,130+_detailSize.size.height)];
        UIImageView * addressBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, headerView.width, 50+_detailSize.size.height)];
        addressBg.image=[UIImage imageNamed:@"ic_choose_address_bg"];
        [headerView addSubview:addressBg];
        
        UILabel * name =[[UILabel alloc]initWithFrame:CGRectMake(35, 15, 200, 15)];
        name.text = _addressModel.pickname;
            name.textColor = [UIColor colorWithHexString:@"595757"];
        name.font = [UIFont systemFontOfSize:15];
        [addressBg addSubview:name];
        
        UILabel * address = [[UILabel alloc]initWithFrame:CGRectMake(35, 35, kScreenWidth-100, _detailSize.size.height)];
        address.numberOfLines = 0;
        address.textColor = [UIColor colorWithHexString:@"595757"];
            address.font = [UIFont systemFontOfSize:15];
        address.text = text2;
        [addressBg addSubview:address];
            
        UIButton *add = [[UIButton alloc]initWithFrame:CGRectMake(20, headerView.height-45, 85, 23)];
        add.layer.cornerRadius = 5;
        add.layer.masksToBounds = YES;
        add.layer.borderWidth = 1;
        add.layer.borderColor = [UIColor blackColor].CGColor;
        [add setTitle:@"使用新地址" forState:UIControlStateNormal];
            [add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            add.titleLabel.font = [UIFont systemFontOfSize:14];
        [add addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchDragInside];
            
        [cell.contentView addSubview:add];
        [cell.contentView addSubview:headerView];}
    }else if (indexPath.section == 1 && indexPath.row == 0){
        //订单号
        UILabel *time_label = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 220, 20)];
        time_label.font = [UIFont systemFontOfSize:12];
        time_label.text = [NSString stringWithFormat:@"订单编号:%@",_buyGoods.buyGoodsON];
        [cell.contentView addSubview:time_label];
        
        //商品编号
        UILabel *paystatus_label = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, kScreenWidth-180, 20)];
        paystatus_label.textAlignment = NSTextAlignmentRight;
        paystatus_label.font = [UIFont systemFontOfSize:12];
        paystatus_label.text = [NSString stringWithFormat:@"商品编号:%@",_buyGoods.buyGoodsBH];
        [cell.contentView addSubview:paystatus_label];
        
        UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 60, 60)];
        NSString *picStr = [NSString stringWithFormat:@"%@%@",YWpic,_goods.pic];
        [picView sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        picView.contentMode = UIViewContentModeScaleToFill;
        [cell.contentView addSubview:picView];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 19, kScreenWidth, 1)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [cell.contentView addSubview:view];
        
        //商品名称
        UITextView *title_label = [[UITextView alloc]initWithFrame:CGRectMake(80, 25, 150, 60)];
        title_label.scrollEnabled = NO;
        title_label.editable = NO;
        title_label.backgroundColor = [UIColor clearColor];
        title_label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:title_label];
        title_label.text = _goods.title;
        
        //原始价格
        UILabel *price_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 25, 80, 30)];
        price_label.textAlignment = NSTextAlignmentRight;
        price_label.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:price_label];
        price_label.text = _goods.selprice;
        
        
        //折后价格
        UILabel *selprice_label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 55, 80, 30)];
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
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [cell.contentView addSubview:line];
        
        cell.textLabel.text = @"购买数量";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 90,7.5, 70, 25)];
        view.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:view];
        
        UIButton *subtract_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 15, 15)];
        [subtract_btn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        [subtract_btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        subtract_btn.tag = 1;
        [view addSubview:subtract_btn];
        
        _num = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 30, 25)];
        _num.borderStyle = UITextBorderStyleNone;
        _num.text = @"1";
        _num.font = [UIFont systemFontOfSize:20];
        _num.enabled = NO;
        _num.selected = NO;
        _num.textAlignment = NSTextAlignmentCenter;
        [view addSubview:_num];
        
        UIButton *add_btn = [[UIButton alloc]initWithFrame:CGRectMake(55, 5, 15, 15)];
        [add_btn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        add_btn.tag = 2;
        [add_btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:add_btn];
        [cell.contentView addSubview:view];
        
    }else if (indexPath.section ==1 && indexPath.row == 2){
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [cell.contentView addSubview:line];
        
        cell.textLabel.text = @"支付方式";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        UIButton *pay_btn1 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-230, 5, 100, 30)];
        UIButton *pay_btn2 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-120, 5, 100, 30)];
        [pay_btn1 setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
        [pay_btn1 setImage:[UIImage imageNamed:@"3"] forState:UIControlStateSelected];
        [pay_btn2 setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
        [pay_btn2 setImage:[UIImage imageNamed:@"3"] forState:UIControlStateSelected];
        [pay_btn1 setTitle:@"余额支付" forState:UIControlStateNormal];
        [pay_btn2 setTitle:@"推荐人代付" forState:UIControlStateNormal];
        [pay_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        pay_btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [pay_btn1 setBackgroundImage:[UIImage imageWithColor:KviewColor] forState:UIControlStateHighlighted];
        [pay_btn2 setBackgroundImage:[UIImage imageWithColor:KviewColor] forState:UIControlStateHighlighted]; 
        
        [pay_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        pay_btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        pay_btn1.tag = 0;
        pay_btn2.tag = 2;
        [pay_btn1 addTarget:self action:@selector(payWay:) forControlEvents:UIControlEventTouchUpInside];
        [pay_btn2 addTarget:self action:@selector(payWay:) forControlEvents:UIControlEventTouchUpInside];
        pay_btn1.selected = YES;
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
        return 120+_detailSize.size.height;
    }
    else if (indexPath.section ==1 && indexPath.row == 0){
        return 90;
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

- (void)addAddress:(UIButton*)sender{
    YWAddressController *addressVC = [[YWAddressController alloc]init];
    [self.navigationController pushViewController:addressVC  animated:YES];
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
    _price.text = [NSString stringWithFormat:@"共计%@件商品 合计：%.1f米",_num.text,[_goods.selprice floatValue]*number];
}

- (void)payWay:(UIButton *)sender{
    if (_last_btn.tag == sender.tag) {
        return;
    }
    sender.selected = YES;
    _last_btn.selected = NO;
    _last_btn = sender;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"E5E6E6"];
    return view;
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *parameters = [Utils paramter:Goods_buy ID:user.ID];
    parameters[@"gid"] = [[_goods.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    parameters[@"gnum"] = [[@"1" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];

    [YWHttptool Post:YWGoodBuy parameters:parameters success:^(id responseObject) {
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
