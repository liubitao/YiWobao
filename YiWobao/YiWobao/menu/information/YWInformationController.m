//
//  YWInformationController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/5.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWInformationController.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "Utils.h"
#import "YWWriterViewController.h"
#import "YWHttptool.h"
#import "MBProgressHUD+MJ.h"
#import <MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface YWInformationController (){
    NSArray *_settingTitles;
    NSMutableArray *_detailedArray;
}

@end

@implementation YWInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.tableView.backgroundColor = KviewColor;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    
    self.tableView.bounces = NO;

    _settingTitles = @[@[@"头像"],@[@"姓名",@"手机"],@[@"微信账号"],@[@"开户银行",@"银行账号"]];
    _detailedArray = [self dataArray];

}

- (NSMutableArray *)dataArray{

    YWUser *user = [YWUserTool account];
    if ([Utils isNull:user.username]) {
        user.username = user.wxname;
    }
    if ([Utils isNull:user.bankname]) {
        user.bankname = @"请添加银行名(精确到支行)";
    }if ([Utils isNull:user.banknum]) {
        user.banknum = @"请添加银行账号";
    }
    if ([Utils isNull:user.phone]) {
        user.phone = @"请添加手机号码";
    }
    if ([Utils isNull:user.bankaccount]) {
        user.bankaccount = @"请添加开户人";
    }
    return [NSMutableArray arrayWithArray:@[@[user.userimg],@[user.username,user.phone],@[user.wxname],@[user.bankname,user.banknum]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _settingTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dataArray = _settingTitles[section];
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"infoCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = _settingTitles[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-100,10, 65, 65)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_detailedArray[indexPath.section][indexPath.row]] placeholderImage:[UIImage imageNamed:@"default－portrait"]];
        [cell.contentView addSubview:imageView];
        imageView.layer.cornerRadius = 65/2;
        imageView.layer.masksToBounds = YES;
        return cell;
    }
    if (indexPath.section == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.detailTextLabel.text = _detailedArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.font = [UIFont fontWithName:@"FZLanTingHei-L-GBK" size:15];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 85;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0|| indexPath.section == 2 ) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWWriterViewController *writerVC = [[YWWriterViewController alloc]init];
    [self.navigationController pushViewController:writerVC animated:YES];
    __weak YWInformationController *weakSelf = self;
   [writerVC returnText:^(NSString *showText) {
       YWUser *user = [YWUserTool account];
       if (indexPath.section == 1 && indexPath.row == 0) {
           user.username = showText;
       }else if (indexPath.section == 1 && indexPath.row == 1){
           if ([Utils checkTelNumber:showText]) {
           user.phone = showText;
           }else{
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"你输入的电话号码有误" preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新输入" style:(UIAlertActionStyleCancel) handler:nil];
               [alertController addAction:cancelAction];
               [writerVC presentViewController:alertController animated:NO completion:nil];
               return ;
           }
       }else if (indexPath.section == 3 && indexPath.row == 0){
            user.bankname = showText;
       }else if (indexPath.section ==3 && indexPath.row == 1){
           if ([Utils checkCardNo:showText]) {
               user.banknum = showText;
           }else{
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"你输入的银行卡号有误" preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新输入" style:(UIAlertActionStyleCancel) handler:nil];
               [alertController addAction:cancelAction];
               [writerVC presentViewController:alertController animated:NO completion:nil];
               return ;
           }
       }
       [weakSelf updataAccountWith:user];
       [writerVC.navigationController popViewControllerAnimated:YES];
   }];
    
}

- (void)updataAccountWith:(YWUser*)user{
    [MBProgressHUD showMessage:@"正在保存" toView:self.view];
    NSMutableDictionary *parameter = [Utils paramter:Edit ID:user.ID];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:user.mj_keyValues options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parameter[@"bhinfo"] = str;
    [YWHttptool Post:YWEdit parameters:parameter success:^(id responseObject) {
        YWUser *user = [YWUser yw_objectWithKeyValues:responseObject[@"result"]];
        [YWUserTool saveAccount:user];
        _detailedArray = [self dataArray];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showSuccess:@"保存完成" toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}


@end
