//
//  YWGuideViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/7/14.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWGuideViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YWHttptool.h"
#import <NSString+MD5.h>
#import "YWWelfare.h"
#import "YWTableViewCell.h"
#import "YWWelfareView.h"
#import "YWDetailsViewController.h"
#import "YWUser.h"
#import "YWUserTool.h"

@interface YWGuideViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray* dataArray;
@property (nonatomic,strong) UITableView* tableView;


@end

@implementation YWGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"福利列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"E4E4E4"];
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"YWTableViewCell" bundle:nil] forCellReuseIdentifier:@"welfare"];
    [self request];
}

- (void)request{
    [MBProgressHUD showMessage:@"正在加载..." toView:_tableView];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[zcproj MD5Digest],sKey]MD5Digest];
    parameter[@"bhim"] = [[user.pid dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool Post:YWzcproj parameters:parameter success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        [MBProgressHUD hideHUDForView:_tableView];
        NSLog(@"%@",responseObject);
        if (!isError) {
            _dataArray = [YWWelfare yw_objectWithKeyValuesArray:responseObject[@"result"]];
            [self.tableView reloadData];
            return ;
            }
         [MBProgressHUD showSuccess:responseObject[@"errorMessage"] toView:_tableView];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_tableView animated:YES];
        [MBProgressHUD showError:@"请检查网络..." toView:_tableView];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"welfare" forIndexPath:indexPath];

    [cell setModel:_dataArray[indexPath.section]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kScreenWidth-55)/4+245-95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWDetailsViewController *detailsVC = [[YWDetailsViewController alloc]init];
    YWWelfare *wel = _dataArray[indexPath.section];
    detailsVC.welfare = wel;
    [self.navigationController pushViewController:detailsVC animated:YES];
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
