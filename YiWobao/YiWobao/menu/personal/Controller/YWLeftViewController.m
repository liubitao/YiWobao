//
//  YWLeftViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWLeftViewController.h"
#import "YWUser.h"
#import "YWUserTool.h"

@interface YWLeftViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *positions;
}
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation YWLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat widthView = kScreenWidth-66;
    self.view.frame = CGRectMake(33, 150, widthView, 338);
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 0, widthView-40, 338) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    [self.view addSubview: self.tableView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, widthView-40, 160)];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, widthView-40, 14)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:12];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 , widthView-40, 24)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont boldSystemFontOfSize:23];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, widthView-40, 15)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:14];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 127, widthView-40, 15)];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:14];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 159, widthView-40, 0.5)];
    view1.backgroundColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:0.5];
    [view addSubview:view1];
    
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    [view addSubview:label4];
    
    YWUser *user = [YWUserTool account];
    label1.text = @"您的推荐人";
    label2.text = user.tjrname;
    NSInteger i = [user.pid intValue]+500000;
    label3.text = [NSString stringWithFormat:@"编号：%ld",i];
    label4.text = [NSString stringWithFormat:@"手机：%@",user.tjrphone];
    
    positions = @[@"总裁",@"总监",@"经理"];
    
    self.tableView.tableHeaderView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *leftID = @"leftID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:leftID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.left = 18;
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    cell.textLabel.text = positions[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = _dataArray[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [_delegate didSelectRowAtIndexPath:indexPath];
    }
    
}




@end
