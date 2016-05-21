//
//  YWOrderViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWOrderViewController.h"
#import "YWHttptool.h"
#import "YWOrderCell.h"
#import "YWOrderModel.h"
#import "Utils.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "MBProgressHUD+MJ.h"


@interface YWOrderViewController ()
{
    NSMutableArray *_dataArray;
    UILabel *label;
    
}

@end

@implementation YWOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KviewColor;
    _dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, self.view.center.y-50, kScreenWidth, 40);
    label.text = @"您还没有相关的订单";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = YES;
    [self.view addSubview:label];
    //请求数据
    [self request];
}

- (void)request{
     label.hidden = YES;
    [MBProgressHUD showMessage:@"正在获取数据"];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:Trlist ID:user.ID];
    paramter[@"okd"] = [[_type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWOrderList parameters:paramter success:^(id responseObject) {
        YWLog(@"%@",responseObject);
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            NSArray *array = responseObject[@"result"];
            if ([Utils isNull:array]) {
                label.hidden = NO;
            }else{
            for (NSDictionary *dict in array) {
               YWOrderModel *orderModel = [YWOrderModel yw_objectWithKeyValues:dict];
                [_dataArray addObject:orderModel];
            }
                [self.tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:nil];
        }
        else{
            [MBProgressHUD showError:@"获取失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWOrderCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (!cell) {
        cell = [[YWOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
    }
    [cell setModel:_dataArray[indexPath.section]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}



@end
