//
//  YWtransferViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/18.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWtransferViewController.h"
#import "YWSearchBar.h"
#import "YWTurnViewController.h"
#import "Utils.h"
#import "YWHttptool.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import <MBProgressHUD.h>

@interface YWtransferViewController ()<UITextFieldDelegate>{
    UIButton *next;
    YWSearchBar *searchBar;
    MBProgressHUD *_hudView;
}

@end

@implementation YWtransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账";
    self.view.backgroundColor = KviewColor;
    searchBar = [[YWSearchBar alloc]initWithFrame:CGRectMake(0, 85, kScreenWidth, 50)];
    searchBar.placeholder = @"请输入转账的编号";
    searchBar.keyboardType = UIKeyboardTypeNumberPad;
    searchBar.delegate = self;
    
    searchBar.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:searchBar];
    
    next = [[UIButton alloc]initWithFrame:CGRectMake(20,160, kScreenWidth-40, 50)];
    next.enabled = NO;
    [next setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:22/255.0 green:116/255.0 blue:200/255.0 alpha:1]] forState:UIControlStateNormal];
    [next setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitle:@"下一步" forState:UIControlStateDisabled];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    next.layer.cornerRadius = 10;
    next.layer.masksToBounds = YES;
    [self.view addSubview:next];
    
}

-(void)next:(UIButton *)sender{
    YWUser *user = [YWUserTool account];
    if ([[NSString stringWithFormat:@"50%@",user.ID] isEqualToString:searchBar.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"不能把自己的余额转给自己" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:NO completion:nil];
    }else{
    _hudView = [Utils createHUD];
    _hudView.userInteractionEnabled = NO;
    _hudView.labelText = @"正在获取";
    [_hudView hide:YES afterDelay:1];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[Getinfo MD5Digest],sKey]MD5Digest];
    paramters[@"tbh"] = [[searchBar.text dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWGetinfo parameters:paramters success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError && ![Utils isNull:responseObject[@"result"]]) {
            YWTurnViewController *turnVC = [[YWTurnViewController alloc]init];
            YWUser *user = [YWUser yw_objectWithKeyValues:responseObject[@"result"][0]];
            turnVC.user = user;
            turnVC.user.ID = searchBar.text;
            [self.navigationController pushViewController:turnVC animated:YES];
        }else{
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"输入的编号有误";
        }
    } failure:^(NSError *error){
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"网络异常，请检查网络";
    }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (range.location == 5 && range.length == 0) {
        next.enabled = YES;
    }
    else if (range.location == 6 ) {
        return NO;
    }
    else{
        next.enabled = NO;
    }
    return YES;
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
