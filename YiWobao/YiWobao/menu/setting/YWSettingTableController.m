//
//  YWSettingTableController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/5.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWSettingTableController.h"
#import "YWInformationController.h"
#import "YWUserTool.h"
#import "YWmainViewController.h"

@interface YWSettingTableController (){
    NSArray *_settingImages;
    NSArray *_settingTitles;
    NSArray *_settingClass;
}

@end

@implementation YWSettingTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.backgroundColor = KviewColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    _settingTitles = @[@"个人信息修改",@"管理收货地址",@"支付密码修改",@"登录密码修改",@"清除缓存"];
    _settingImages = @[@"ic_person",@"ic_home",@"ic_lock",@"ic_phonelink_lock",@"ic_clear"];
    _settingClass = @[[YWInformationController class]];

    //添加退出按钮
    UIButton *exitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KscreenHeight-114, kScreenWidth, 50)];
    exitButton.backgroundColor = [UIColor redColor];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
   
    [exitButton addTarget:self action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
}

- (void)exit:(UIButton *)sender{
    //设置提醒框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //删除存储在本地的用户信息
        [YWUserTool quit];
        //跳转到主界面
        YWmainViewController *mainVC = [[YWmainViewController alloc]init];
        [self presentViewController:mainVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertController addAction:action1];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _settingTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.imageView.image = [UIImage imageNamed:_settingImages[indexPath.row]];
    cell.textLabel.text = _settingTitles[indexPath.row];
    
    //设置cell上图片和文字的大小
    CGSize itemSize = CGSizeMake(30,30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 49-1, kScreenWidth, 1)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [cell.contentView addSubview:view];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *VC = [[(Class )_settingClass[indexPath.row] alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

@end
