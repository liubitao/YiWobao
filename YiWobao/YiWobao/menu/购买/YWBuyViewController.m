//
//  YWBuyViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/20.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWBuyViewController.h"
#import "YWGoods.h"

@interface YWBuyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_buttomView;
}

@end

@implementation YWBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, KscreenHeight-20-80) style:UITableViewStyleGrouped];
    
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
    
    UILabel* price=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 170, 60)];
    price.textColor=[UIColor whiteColor];
    price.font=[UIFont systemFontOfSize:18];
    price.text=[NSString stringWithFormat:@"实付款：%@",_goods.selprice];
    [_buttomView addSubview:price];
    
    UIButton *addCart = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-140, 0, 140, 60)];
    [addCart setTitle:@"提交订单" forState:UIControlStateNormal];
    [addCart addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [addCart.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [addCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCart setBackgroundColor:[UIColor colorWithRed:255/255.0 green:100/255.0 blue:98/255.0 alpha:1]];
    [_buttomView addSubview:addCart];
   
}

- (void)submitClick{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyCell"];
    }
    if (indexPath.section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 115)];
        UIImageView * addressBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, headerView.width, headerView.height-15)];
        addressBg.image=[UIImage imageNamed:@"address_info_bg"];
        [headerView addSubview:addressBg];
        UIImageView * nameImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
        nameImg.contentMode =  UIViewContentModeCenter;
        nameImg.image=[UIImage imageNamed:@"address_name_icon"];
        [addressBg addSubview:nameImg];
        UILabel * name =[[UILabel alloc]initWithFrame:CGRectMake(30, 20, 100, 20)];
        name.text=@"丁博洋";
        [addressBg addSubview:name];
        
        UIImageView * phoneImg=[[UIImageView alloc]initWithFrame:CGRectMake(130, 20, 20, 20)];
        phoneImg.contentMode =  UIViewContentModeCenter;
        phoneImg.image=[UIImage imageNamed:@"address_phone_icon"];
        [addressBg addSubview:phoneImg];
        
        UILabel * phone =[[UILabel alloc]initWithFrame:CGRectMake(155, 20, 100, 20)];
        phone.text=@"158****1990";
        [addressBg addSubview:phone];
        
        UILabel * address = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, headerView.width-30, 40)];
        address.font=[UIFont systemFontOfSize:14];
        address.textColor=[UIColor darkGrayColor];
        address.numberOfLines =2;
        address.text=@"辽宁沈阳市铁西区二环内保工街12路狮城花园11号楼2-6-1";
        [addressBg addSubview:address];
        
        UIImageView * moreImg =[[UIImageView alloc]initWithFrame:CGRectMake(headerView.width-30, 0, 30, headerView.height)];
        moreImg.contentMode =  UIViewContentModeCenter;
        moreImg.image=[UIImage imageNamed:@"address_more_icon"];
        [addressBg addSubview:moreImg];
        
        [cell.contentView addSubview:headerView];
    }else{
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 115;
    }
    return 0;
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
