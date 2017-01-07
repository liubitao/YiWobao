//
//  YWClaimListViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/30.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWClaimListViewController.h"
#import "YWClaimListViewCell.h"
#import "YWclaimModel.h"
#import "YWUser.h"
#include "YWUserTool.h"
#import "YWHttptool.h"
#import "MBProgressHUD+MJ.h"
#import "YWDetailsViewController.h"

@interface YWClaimListViewController ()<UITableViewDataSource,UITableViewDelegate,YWClaimListDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation YWClaimListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的福利";
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64-49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerNib:[UINib nibWithNibName:@"YWClaimListViewCell" bundle:nil] forCellReuseIdentifier:@"claimList"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self request];
}
- (void)request{
    [MBProgressHUD showMessage:@"正在加载..." toView:_tableView];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[myProj MD5Digest],sKey]MD5Digest];
    parameter[@"bhim"] = [[user.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool Post:YWmyProj parameters:parameter success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        [MBProgressHUD hideHUDForView:_tableView];
        if (!isError){
            self.dataArray = [YWclaimModel yw_objectWithKeyValuesArray:responseObject[@"result"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_tableView animated:YES];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWClaimListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"claimList" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YWclaimModel *claimModel = self.dataArray[indexPath.row];
    cell.delegate = self;
    [cell setClaimModel:claimModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWWelfare *welfare = self.dataArray[indexPath.row];
    CGRect detailSize = [welfare.title boundingRectWithSize:CGSizeMake(kScreenWidth-105, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}context:nil];
    if (detailSize.size.height<=25){
        detailSize.size.height = 25;
    }else{
        detailSize.size.height = 50;
    }
    return detailSize.size.height+230;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWDetailsViewController *detailsVC = [[YWDetailsViewController alloc]init];
    NSMutableDictionary *parameter1 = [NSMutableDictionary dictionary];
    YWclaimModel *claimModel = self.dataArray[indexPath.row];
    parameter1[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[detail MD5Digest],sKey]MD5Digest];
    parameter1[@"gid"] = [[claimModel.projid dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    parameter1[@"bhim"] = [[[YWUserTool account].ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [MBProgressHUD showMessage:@"加载中..."];
    [YWHttptool Post:YWdetail parameters:parameter1 success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
         [MBProgressHUD hideHUD];
        if (!isError) {
            YWWelfare *model = [YWWelfare yw_objectWithKeyValues:responseObject[@"result"]];
            detailsVC.welfare = model;
            [self pushController:detailsVC];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)click:(NSIndexPath *)indexPath claim:(YWclaimModel *)claimModel{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定申请回购？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YWUser *user = [YWUserTool account];
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[getBack MD5Digest],sKey]MD5Digest];
            parameter[@"bhim"] = [[user.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
            parameter[@"backid"] = [[claimModel.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
            [YWHttptool Post:YWgetBack parameters:parameter success:^(id responseObject) {
                NSInteger isError = [responseObject[@"isError"] integerValue];
                [MBProgressHUD hideHUDForView:self.view];
                if (!isError) {
                    [MBProgressHUD showSuccess:responseObject[@"errorMessage"] toView:self.view];
                    claimModel.backstsc = @"1";
                    self.dataArray[indexPath.section] = claimModel;
                    [self.tableView reloadData];
                    return ;
                }
                [MBProgressHUD showError:responseObject[@"errorMessage"]  toView:self.view];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"请检查网络" toView:self.view];
            }];
            
        }];
        [alert addAction:cancel];
        [alert addAction:action];
     [self presentViewController:alert animated:YES completion:nil];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有认领过福利";
    return [[NSAttributedString alloc] initWithString:text attributes:@{
                                                                        NSFontAttributeName:[UIFont systemFontOfSize:17]
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
