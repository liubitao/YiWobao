//
//  YWShopClassViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/10/8.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWShopClassViewController.h"
#import "YwFederalCell.h"

@interface YWShopClassViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) UITableView *tableView;

@end

@implementation YWShopClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YwFederalCell" bundle:nil] forCellReuseIdentifier:@"shopcell"];
    if([Utils isNull:_federal.shops]){
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, self.view.center.y-50, kScreenWidth, 40);
        label.text = @"您还没有相关的商店";
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _federal.shops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"shopcell";
    
    YwFederalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    YWFederalShop *shop = _federal.shops[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellModel:shop];
    return cell;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 140;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"1");
    
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
