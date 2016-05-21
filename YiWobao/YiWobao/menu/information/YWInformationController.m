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
#import <MBProgressHUD.h>
#import <MJExtension.h>

@interface YWInformationController (){
    NSArray *_settingImages;
    NSArray *_settingTitles;
    NSMutableArray *_detailedArray;
    MBProgressHUD *_hudView;
    
}

@end

@implementation YWInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.tableView.backgroundColor = KviewColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    _settingImages = @[@"ic_person",@"ic_phone",@"weixin_icon_xxh",@"ic_store",@"ic_payment",@"ic_person"];
    _settingTitles = @[@"姓名",@"手机",@"微信账号",@"开户银行",@"银行账号",@"开户人"];
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
    return [NSMutableArray arrayWithArray:@[user.username,user.phone,user.wxname,user.bankname,user.banknum,user.bankaccount]];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"infoCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.imageView.image = [UIImage imageNamed:_settingImages[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = _settingTitles[indexPath.row];
    
    //设置cell上图片和文字的大小
    CGSize itemSize = CGSizeMake(30,30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 45-1, kScreenWidth, 1)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [cell.contentView addSubview:view];
    
    cell.detailTextLabel.text = _detailedArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YWWriterViewController *writerVC = [[YWWriterViewController alloc]init];
    [self.navigationController pushViewController:writerVC animated:YES];
    __weak YWInformationController *weakSelf = self;
   [writerVC returnText:^(NSString *showText) {
       YWUser *user = [YWUserTool account];
       switch (indexPath.row) {
           case 0:
               user.username = showText;
               break;
           case 1:
               if ([Utils checkTelNumber:showText]) {
                   user.phone = showText;
               }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"你输入的电话号码有误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新输入" style:(UIAlertActionStyleCancel) handler:nil];
                [alertController addAction:cancelAction];
                [writerVC presentViewController:alertController animated:NO completion:nil];
                   return ;
               }
               break;
           case 2:
               user.wxname = showText;
               break;
           case 3:
               user.bankname = showText;
               break;
           case 4:
               if ([Utils checkCardNo:showText]) {
                   user.banknum = showText;
               }else{
                   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"你输入的银行卡号有误" preferredStyle:UIAlertControllerStyleAlert];
                   UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新输入" style:(UIAlertActionStyleCancel) handler:nil];
                   [alertController addAction:cancelAction];
                   [writerVC presentViewController:alertController animated:NO completion:nil];
                   return ;
               }
               break;
            case 5:
               user.bankaccount = showText;
               break;
           default:
               break;
       }
       [weakSelf updataAccountWith:user];
       [writerVC.navigationController popViewControllerAnimated:YES];
   }];
    
}

- (void)updataAccountWith:(YWUser*)user{
    _hudView = [Utils createHUD];
    _hudView.userInteractionEnabled = NO;
    _hudView.labelText = @"正在修改";
    NSMutableDictionary *parameter = [Utils paramter:Edit ID:user.ID];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:user.mj_keyValues options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parameter[@"bhinfo"] = str;
    [YWHttptool Post:YWEdit parameters:parameter success:^(id responseObject) {
        YWUser *user = [YWUser yw_objectWithKeyValues:responseObject[@"result"]];
        [YWUserTool saveAccount:user];
        [_hudView hide:YES];
        _detailedArray = [self dataArray];
        [self.tableView reloadData];
        
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hudView.labelText = @"修改成功";
        [_hudView hide:YES afterDelay:2];
        
    } failure:^(NSError *error) {
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"网络异常，修改失败";
        [_hudView hide:YES afterDelay:1];
    }];
    

}


@end
