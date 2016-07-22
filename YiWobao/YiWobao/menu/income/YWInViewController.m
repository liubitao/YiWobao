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
#import "MBProgressHUD+MJ.h"

@interface YWInViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_hudView;
}
@property (weak, nonatomic) IBOutlet UILabel *cardBank;
@property (weak, nonatomic) IBOutlet UILabel *cardMan;
@property (weak, nonatomic) IBOutlet UILabel *cardAccount;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UIButton *inCome;

@end

@implementation YWInViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    self.view.backgroundColor = KviewColor;
    
    _inCome.layer.masksToBounds = YES;
    _inCome.layer.cornerRadius = 5;
    
    //获取数据
    [self getData];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gesture];
    
    _number.delegate = self;
}



- (void)getData{
    YWUser *user = [YWUserTool account];
    if ([Utils isNull:user.bankname]||[Utils isNull:user.bankname]||[Utils isNull:user.bankaccount]) {
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MBProgressHUD showMessage:@"正在支付" toView:self.view];
            YWUser *user = [YWUserTool account];
            if ([user.paypwd isEqualToString:[alertController.textFields[0].text MD5Digest]]) {
                NSMutableDictionary *parameter = [Utils paramter:Pick ID:user.ID];
                parameter[@"txym"] = [[_number.text dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
                [YWHttptool GET:YWPick  parameters:parameter success:^(id responseObject) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSInteger isError = [responseObject[@"isError"] integerValue];
                    if (!isError) {
                        [MBProgressHUD showSuccess:@"提现成功"];
                    }else{
                        [MBProgressHUD showError:@"提现失败"];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showError:@"请检查网络"];
                }];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"密码输入错误或您还未设置初始密码"];
            }
        }]];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入支付密码";
            textField.secureTextEntry = YES;
            textField.font = [UIFont systemFontOfSize:15];
            textField.borderStyle = UITextBorderStyleNone;
        }];
        
        [alertController.actions[0] setValue:[UIColor redColor] forKeyPath:@"_titleTextColor"];
        
        [self presentViewController:alertController animated:true completion:nil];
        

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length == 9 && ![Utils isNull:string]) {
        return NO;
    }
    NSScanner      *scanner    = [NSScanner scannerWithString:string];
    
    NSCharacterSet *numbers;
    
    NSRange         pointRange = [textField.text rangeOfString:@"."];
    if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
    {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    else{
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    }
    if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] ){
        return NO;
    }
    short remain = 2; //默认保留2位小数
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
        if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
            return NO;
        }
        if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
            return NO;
        }
    }
    NSRange zeroRange = [textField.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
        if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
            textField.text = string;
            return NO;
        }else{
            if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                if([string isEqualToString:@"0"]){
                    return NO;
                }
            }
        }
    }
    NSString *buffer;
    if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
    {
        return NO;
    }
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([_number isFirstResponder]) {
        [_number resignFirstResponder];
    }
    [super viewWillDisappear:animated];

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
