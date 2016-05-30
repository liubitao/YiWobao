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
#import "CYPasswordView.h"
#import <NSString+MD5.h>

#define kRequestTime 3.0f
#define kDelay 1.0f

@interface YWOrderViewController ()<YWOrderCellDelegate>
{
    UILabel *label;
    
}
@property (nonatomic, strong) CYPasswordView *passwordView;
@property (nonatomic,strong) NSMutableArray *dataArray;

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
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:Trlist ID:user.ID];
    paramter[@"okd"] = [[_type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWOrderList parameters:paramter success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            [_dataArray removeAllObjects];
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
    YWOrderModel *orederModel = _dataArray[indexPath.section];
    YWOrderCell  *cell;
    if ([_type isEqualToString:@"3"]) {
        if ([orederModel.paystatus isEqualToString:@"0"] && [orederModel.paykind isEqualToString:@"2"]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell3"];
            if (!cell) {
                cell = [[YWOrderCell alloc]                         initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell3"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.type = @"2";
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell2"];
            if (!cell) {
                cell = [[YWOrderCell alloc]                         initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.type = @"2";
            }
        }
    }else{
    
    if ([orederModel.paystatus isEqualToString:@"0"] && [orederModel.paykind isEqualToString:@"2"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell1"];
        if (!cell) {
            cell = [[YWOrderCell alloc]                         initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             cell.type = @"1";
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell2"];
        if (!cell) {
            cell = [[YWOrderCell alloc]                         initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = @"1";
        }
    }}
    [cell setModel:_dataArray[indexPath.section]];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWOrderModel *orederModel = _dataArray[indexPath.section];
    if ([orederModel.paystatus isEqualToString:@"0"] && [orederModel.paykind isEqualToString:@"2"]) {
        return 150;
    }
    return  120;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void)changeState:(NSIndexPath *)indexPath tag:(NSInteger)tag type:(NSString *)type{
    if (tag == 1) {
        NSString *str = [type isEqualToString:@"1"]?  @"正在取消订单":@"正在拒绝代付";
        NSString *str2 = [type isEqualToString:@"1"]?  @"已取消":@"已拒绝";
        [MBProgressHUD showMessage:str];
        YWOrderModel *orederModel = _dataArray[indexPath.section];
        YWUser *user = [YWUserTool account];
        NSMutableDictionary *parameters = [Utils paramter:Del_order ID:user.ID];
        parameters[@"doid"] = [[orederModel.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
        parameters[@"dkd"] = [[type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
        [YWHttptool Post:YWDelOrder parameters:parameters success:^(id responseObject) {
            NSInteger isError = [responseObject[@"isError"] integerValue];
            [MBProgressHUD hideHUD];
            if (!isError) { 
                [self request];
                [MBProgressHUD showSuccess:str2];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请检查网络"];
        }];
    }else{
        YWLog(@"分享代付码");
        if ([type isEqualToString:@"2"]) {
            __weak YWOrderViewController *weakSelf = self;
            self.passwordView = [[CYPasswordView alloc] init];
            self.passwordView.title = @"输入交易密码";
            self.passwordView.loadingText = @"提交中...";
            [self.passwordView showInView:self.view.window];
            self.passwordView.finish = ^(NSString *password) {
                [weakSelf.passwordView hideKeyboard];
                [weakSelf.passwordView startLoading];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kRequestTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    YWUser *user = [YWUserTool account];
                    NSMutableDictionary *paramters = [Utils paramter:do_order ID:user.ID];
                    NSMutableDictionary *payarr = [NSMutableDictionary dictionary];
                    YWOrderModel *orederModel = weakSelf.dataArray[indexPath.section];
                    payarr[@"oid"] = orederModel.ID;
                    payarr[@"pkd"] = @"0";
                    payarr[@"pwd"] = [password MD5Digest];
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payarr options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    paramters[@"payarr"] = str;
                    [YWHttptool Post:YWDoOrder parameters:paramters success:^(id responseObject) {
                        NSInteger isError = [responseObject[@"isError"] integerValue];
                        if (!isError) {
                            [MBProgressHUD showSuccess:@"支付成功"];
                            [weakSelf.passwordView requestComplete:YES message:@"支付成功"];
                            [weakSelf.passwordView stopLoading];
                            [weakSelf.passwordView hide];
                            [weakSelf request];
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
    }
        
}



@end
