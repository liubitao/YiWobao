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
#import <MBProgressHUD.h>


@interface YWOrderViewController ()
{
    NSMutableArray *_dataArray;
    MBProgressHUD *_hudView;
    
}

@end

@implementation YWOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = KviewColor;
    _dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    //请求数据
    [self request];
}

- (void)request{
    _hudView = [Utils createHUD];
    _hudView.userInteractionEnabled = NO;
    _hudView.labelText = @"正在获取数据";
    [_hudView hide:YES afterDelay:1];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:Trlist ID:user.ID];
    paramter[@"okd"] = [[_type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWOrderList parameters:paramter success:^(id responseObject) {
        YWLog(@"%@",responseObject);
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            NSArray *array = responseObject[@"result"];
            if ([Utils isNull:array]) {
                UILabel *label = [[UILabel alloc]init];
                label.frame = CGRectMake(0, self.view.center.y-50, kScreenWidth, 40);
                label.text = @"您还没有相关的订单";
                label.font = [UIFont systemFontOfSize:20];
                label.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:label];
            }else{
            for (NSDictionary *dict in array) {
               YWOrderModel *orderModel = [YWOrderModel yw_objectWithKeyValues:dict];
                [_dataArray addObject:orderModel];
            }
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, self.view.center.y-50, kScreenWidth, 40);
        label.text = @"网络异常，请检查网络";
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"网络异常，请检查网络";
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
