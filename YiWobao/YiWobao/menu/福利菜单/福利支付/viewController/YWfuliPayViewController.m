//
//  YWfuliPayViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 2017/1/5.
//  Copyright © 2017年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWfuliPayViewController.h"
#import "YWAddressModel.h"
#import "YWAddressController.h"
#import "YWCodeViewController.h"


@interface YWfuliPayViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CGRect _detailSize;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *num;
@property (nonatomic,strong) UITextField *beizhu;

@property (nonatomic,strong) YWAddressModel *addressModel;

@end

@implementation YWfuliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"E5E6E6"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64-50) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"E5E6E6"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *addCart = [[UIButton alloc]initWithFrame:CGRectMake(0, KscreenHeight-50,kScreenWidth, 50)];
    addCart.backgroundColor = KthemeColor;
    [addCart setTitle:@"认领" forState:UIControlStateNormal];
    [addCart addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [addCart.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [addCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:addCart];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *parameters = [Utils paramter:Addres ID:user.ID];
    
    [YWHttptool Post:YWAddrList parameters:parameters success:^(id responseObject) {
        if (![Utils isNull:responseObject[@"result"]]) {
            
            NSMutableArray *Addressarray = [YWAddressModel yw_objectWithKeyValuesArray:responseObject[@"result"]];
            if ([Utils isNull:Addressarray]) {
                _addressModel = nil;
            }else{
                for (YWAddressModel *model in Addressarray) {
                    if ([model.isselect isEqualToString:@"1"]) {
                        _addressModel = model;
                    }
                }
            }
            [_tableView reloadData];
        }
        else{
            [MBProgressHUD showError:responseObject[@"errorMessage"]];
            
        }
    } failure:^(NSError *error) {
    }];
}

//提交订单
- (void)submitClick{
    if (_num.text.intValue < _welfare.sprice.intValue || _num.text.intValue >_welfare.topprice.intValue) {
        [UIAlertController showAlertViewWithTitle:@"提醒" Message:@"您输入认领份数有误" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    if ([Utils isNull:self.addressModel]) {
        [UIAlertController showAlertViewWithTitle:@"提醒" Message:@"请完善你的地址" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    if(_num.text.length == 0){
        [UIAlertController showAlertViewWithTitle:@"提醒" Message:@"您输入的认领详情有误" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    YWCodeViewController *codeVC = [[YWCodeViewController alloc]init];
    codeVC.type = @"buy_proj";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"zcxmid"] = _welfare.ID;
    dict[@"sprice"] = _num.text;
    dict[@"username"] = self.addressModel.pickname;
    dict[@"pkd"] = @"0";
    dict[@"phone"] = self.addressModel.pickphone;
    dict[@"omeno"] = _beizhu.text;
    dict[@"addrid"] = self.addressModel.ID;
    codeVC.buyDic = dict;
    [self presentViewController:codeVC animated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyCell"];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"buyCell"];
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
        cell.textLabel.text = @"最小认领数";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.text = [NSString stringWithFormat:@" %@ ",self.welfare.sprice];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.backgroundColor = KthemeColor;
        
    }else if (indexPath.section ==1 && indexPath.row == 1){
        cell.textLabel.text = @"最大认领数";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = [UIColor whiteColor   ];
        cell.detailTextLabel.text = [NSString stringWithFormat:@" %@ ",self.welfare.topprice];
        cell.detailTextLabel.backgroundColor = KthemeColor;
    }else if (indexPath.section ==1 && indexPath.row == 2){
        cell.textLabel.text = @"认领份数";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        _num = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth - 120, 10, 100, 30)];
        _num.text = [NSString stringWithFormat:@"%d",self.welfare.sprice.intValue];
        _num.borderStyle = UITextBorderStyleRoundedRect;
        _num.font = [UIFont systemFontOfSize:17];
        _num.keyboardType = UIKeyboardTypeNumberPad;
        _num.textAlignment = NSTextAlignmentCenter;
        if ([self.welfare.isgd isEqualToString:@"1"]) {
            _num.enabled = NO;
        }
        [cell.contentView addSubview:_num];
    }else if (indexPath.section ==1 && indexPath.row == 3){
        cell.textLabel.text = @"支付方式";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        UIImageView *payImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-120, 15, 20, 20)];
        payImg.image = [UIImage imageNamed:@"paySelected"];
        payImg.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:payImg];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-90, 15, 80, 20)];
        label.text = @"蚁米支付";
        [cell.contentView addSubview:label];
    }else if (indexPath.section ==1 && indexPath.row == 4){
        cell.textLabel.text = @"备注";
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        _beizhu = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth - 200, 10, 180, 30)];
        _beizhu.placeholder = @"填写备注";
        _beizhu.font = [UIFont systemFontOfSize:17];
        _beizhu.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:_beizhu];
    }
    return cell;
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
    [self hideBottomBarPush:addressVC];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([Utils isNull:_addressModel]) {
            return 50;
        }
        return 120+_detailSize.size.height;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
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
