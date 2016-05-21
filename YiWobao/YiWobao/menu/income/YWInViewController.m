//
//  YWInViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/13.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWInViewController.h"
#import "Utils.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "YWHttptool.h"
#import <MBProgressHUD.h>

@interface YWInViewController ()<UIGestureRecognizerDelegate>
{
    MBProgressHUD *_hudView;
}
@property (weak, nonatomic) IBOutlet UILabel *cardBank;
@property (weak, nonatomic) IBOutlet UILabel *cardMan;
@property (weak, nonatomic) IBOutlet UILabel *cardAccount;
@property (weak, nonatomic) IBOutlet UITextField *number;

@end

@implementation YWInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    self.view.backgroundColor = KviewColor;
    //获取数据
    [self getData];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gesture];
}

- (void)getData{
    YWUser *user = [YWUserTool account];
    if ([Utils isNull:user.bankname]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您还没有填写您的银行账号，请到设置的个人中心填写" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:NO completion:nil];
    }
    else{
        _cardBank.text = [NSString stringWithFormat:@"开户银行：%@",user.bankname];
        _cardMan.text = [NSString stringWithFormat:@"开户人：%@",user.bankaccount];
        _cardAccount.text = [NSString stringWithFormat:@"开户账号：%@",user.banknum];
    }
}

- (IBAction)pickCard:(id)sender {
      YWUser *user = [YWUserTool account];
    if ([Utils isNull:user.bankname]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您还没有填写您的银行账号，请到设置的个人中心填写" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:NO completion:nil];
    }
    else if ([Utils isNull:_number.text]||[_number.text intValue]<100) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您提现的金额必须是大于或等于100米" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:NO completion:nil];
    }else{
        _hudView = [Utils createHUD];
        _hudView.userInteractionEnabled = NO;
        _hudView.labelText = @"正在加载";
        [_hudView hide:YES afterDelay:1];
        NSMutableDictionary *parameter = [Utils paramter:Pick ID:user.ID];
        parameter[@"txym"] = [[_number.text dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
        [YWHttptool GET:YWPick  parameters:parameter success:^(id responseObject) {
             NSInteger isError = [responseObject[@"isError"] integerValue];
            if (!isError) {
                _hudView.mode = MBProgressHUDModeCustomView;
                _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-done"]];
                _hudView.labelText = @"提现成功";
            }
            else{
                _hudView.mode = MBProgressHUDModeCustomView;
                _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
                _hudView.labelText = responseObject[@"errorMessage"];
            }
           
        } failure:^(NSError *error) {
            _hudView.mode = MBProgressHUDModeCustomView;
            _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hudView.labelText = @"网络异常，请检查网络";
        }];
    }
    
}
//确定这个手势是否可以实现
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //判断这个账号和密码控件中是否都是第一响应者
    if (![_number isFirstResponder]) {
        //都不是第一响应者的时候
        return NO;
    }
    return YES;
}
//隐藏键盘栏
- (void)hidenKeyboard
{
    [_number resignFirstResponder];
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
