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



@interface YWListViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    NSMutableArray *_dataArray;
}

@end

@implementation YWListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KviewColor;
    _dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"YWCell3" bundle:nil] forCellReuseIdentifier:@"cell3"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self request];
}

- (void)request{
    [MBProgressHUD showMessage:@"正在获取数据" toView:self.tableView];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:Trlist ID:user.ID];
    paramter[@"tkd"] = [[_type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWTrlist parameters:paramter success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            NSArray *array = responseObject[@"result"];
            if (![Utils isNull:array]){
                for (NSDictionary *dict in array) {
                    YWModel4 *model4 = [YWModel4 mj_objectWithKeyValues:dict];
                    [_dataArray addObject:model4];
                }
            }
        }
        [self.tableView reloadData];
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
    YWModel4 *model = _dataArray[indexPath.section];
    CGRect detailSize = [model.memo boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}context:nil];
    if (detailSize.size.height<=33) {
        detailSize.size.height = 33;
    }
    return detailSize.size.height-33+87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无相关记录...";
    return [[NSAttributedString alloc] initWithString:text attributes:@{
                                                                        NSFontAttributeName:[UIFont systemFontOfSize:20]
                                                                        }];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;{
    return -64;
}

@end
