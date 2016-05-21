//
//  YWTurnViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/18.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWTurnViewController.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "YWHttptool.h"
#import "MBProgressHUD+MJ.h"
#import "Utils.h"
#import "CYPasswordView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RegisterController.h"


#define kRequestTime 3.0f
#define kDelay 1.0f

@interface YWTurnViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITextField *money_text;

@property (nonatomic, strong) CYPasswordView *passwordView;

@end

@implementation YWTurnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KviewColor;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:self.user.userimg] placeholderImage:[UIImage imageNamed:@"default－portrait"]];
    if ([Utils isNull:_user.username]) {
        _userName.text = _user.wxname;
    }
    else{
        _userName.text = _user.wxname;
    }
    
    
    /** 注册取消按钮点击的通知 */
    [CYNotificationCenter addObserver:self selector:@selector(cancel) name:CYPasswordViewCancleButtonClickNotification object:nil];
    [CYNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];
   
    
}

//取消
- (void)cancel{
     [MBProgressHUD showSuccess:@"关闭密码框"];
}

//忘记支付密码
- (void)forgetPWD{
    [MBProgressHUD showSuccess:@"忘记密码"];
    [self.passwordView hide];
    RegisterController *VC = [[RegisterController alloc]init];
    VC.title = @"修改支付密码";
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (IBAction)turnMoney:(id)sender {
    __weak YWTurnViewController *weakSelf = self;
    self.passwordView = [[CYPasswordView alloc] init];
    self.passwordView.title = @"输入交易密码";
    self.passwordView.loadingText = @"提交中...";
    [self.passwordView showInView:self.view.window];
    self.passwordView.finish = ^(NSString *password) {
        [weakSelf.passwordView hideKeyboard];
        [weakSelf.passwordView startLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kRequestTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YWUser *user = [YWUserTool account];
            NSMutableDictionary *paramters = [Utils paramter:Trans ID:user.ID];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"tbh"] = weakSelf.user.ID;
            dict[@"tje"] = weakSelf.money_text.text;
            dict[@"tpaypwd"] = [password MD5Digest];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            paramters[@"transarr"] = str;
            [YWHttptool Post:YWTrans parameters:paramters success:^(id responseObject) {
                NSInteger isError = [responseObject[@"isError"] integerValue];
                if (!isError) {
                    [MBProgressHUD showSuccess:@"转账成功"];
                    [weakSelf.passwordView requestComplete:YES message:@"转账成功"];
                    [weakSelf.passwordView stopLoading];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.passwordView hide];
                    });
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [MBProgressHUD showError:responseObject[@"errorMessage"]];
                    [weakSelf.passwordView requestComplete:NO message:responseObject[@"errorMessage"]];
                    [weakSelf.passwordView stopLoading];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.passwordView hide];
                    });
                }
            } failure:^(NSError *error) {
                
            }];
        });
    };

    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
