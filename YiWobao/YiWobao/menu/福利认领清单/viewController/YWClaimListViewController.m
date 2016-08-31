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

@interface YWClaimListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation YWClaimListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"福利清单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"YWClaimListViewCell" bundle:nil] forCellReuseIdentifier:@"claimList"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _welfare.claimArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWClaimListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"claimList" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = _welfare.title;
    cell.memoy.text = _welfare.backfit;
    cell.isback = _welfare.isback;
    [cell setModel:_welfare.claimArray[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    [cell buy_back:^(NSString * backid) {
        YWUser *user = [YWUserTool account];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[getBack MD5Digest],sKey]MD5Digest];
        parameter[@"bhim"] = [[user.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
        YWclaimModel *claimModel = weakSelf.welfare.claimArray[indexPath.row];
        parameter[@"backid"] = [[claimModel.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
        [YWHttptool Post:YWgetBack parameters:parameter success:^(id responseObject) {
            NSInteger isError = [responseObject[@"isError"] integerValue];
            [MBProgressHUD hideHUDForView:weakSelf.view];
            NSLog(@"%@",responseObject);
            if (!isError) {
              [MBProgressHUD showSuccess:responseObject[@"errorMessage"] toView:weakSelf.view];
                return ;
            }
            [MBProgressHUD showError:responseObject[@"errorMessage"]  toView:weakSelf.view];
        } failure:^(NSError *error) {
             [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showError:@"请检查网络" toView:weakSelf.view];
        }];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect detailSize = [_welfare.title boundingRectWithSize:CGSizeMake(kScreenWidth-130, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}context:nil];
    if (detailSize.size.height<=30) {
        detailSize.size.height = 30;
    }
    return detailSize.size.height-30+276;
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
