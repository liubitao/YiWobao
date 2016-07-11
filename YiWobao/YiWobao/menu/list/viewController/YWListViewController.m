//
//  YWListViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/13.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWListViewController.h"
#import "Utils.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "YWHttptool.h"
#import "YWCell3.h"
#import "YWModel4.h"
#import "MBProgressHUD+MJ.h"
#import <MJExtension.h>



@interface YWListViewController (){
    NSMutableArray *_dataArray;
    UILabel *label;
}

@end

@implementation YWListViewController

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
    
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"YWCell3" bundle:nil] forCellReuseIdentifier:@"cell3"];
    
}

- (void)request{
    label.hidden = YES;
    [MBProgressHUD showMessage:@"正在获取数据" toView:self.tableView];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:Trlist ID:user.ID];
    paramter[@"tkd"] = [[_type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWTrlist parameters:paramter success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            NSArray *array = responseObject[@"result"];
            if ([Utils isNull:array]) {
                label.hidden = NO;
            }else{
                for (NSDictionary *dict in array) {
                    YWModel4 *model4 = [YWModel4 mj_objectWithKeyValues:dict];
                    [_dataArray addObject:model4];
                }
                [self.tableView reloadData];
            }
        }else{
             [MBProgressHUD showError:@"获取失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
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
    YWCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_dataArray[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end
