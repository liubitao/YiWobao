//
//  YWNextViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/6/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWNextViewController.h"
#import "YWNextPerson.h"
#import "Utils.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "YWHttptool.h"
#import "MBProgressHUD+MJ.h"

@interface YWNextViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UILabel *label;
}

@end

@implementation YWNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
    
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, self.view.center.y-50, kScreenWidth, 40);
    label.text = @"您还没有相关的下级";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = YES;
    [self.view addSubview:label];
    
    [self request];
    
}

- (void)request{
    [MBProgressHUD showMessage:@"正在加载..." toView:_tableView];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:List ID:user.ID];
    NSString *str = [NSString stringWithFormat:@"%ld",_style];
    paramter[@"zkd"] = [[str dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWList parameters:paramter success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:_tableView];
        if (![Utils isNull:responseObject[@"result"]]) {
            _dataArray = [YWNextPerson yw_objectWithKeyValuesArray:responseObject[@"result"]];
        }else{
                label.hidden = NO;
                return ;
        }
        [_tableView reloadData];
        [MBProgressHUD hideHUDForView:_tableView];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_tableView];
        [MBProgressHUD showError:@"请检查网络" toView:_tableView];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 150, 15, 130, 20)];
        phone.textAlignment = NSTextAlignmentRight;
        phone.tag = 1;
        [cell.contentView addSubview:phone];
    }
    YWNextPerson *person = _dataArray[indexPath.row];
    if ([Utils isNull:person.username]) {
        cell.textLabel.text = person.wxname;
    }else{
        cell.textLabel.text = person.username;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"加入时间：%@",[Utils timeWith:person.regtime]];
    ((UILabel *)[cell.contentView viewWithTag:1]).text = person.phone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
