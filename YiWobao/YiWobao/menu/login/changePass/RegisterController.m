//
//  RegisterController.m
//  XBS
//
//  Created by 刘毕涛 on 15/12/21.
//  Copyright © 2015年 刘毕涛. All rights reserved.
//

#import "RegisterController.h"
#import "Utils.h"
#import <MBProgressHUD.h>
#import "YWUserTool.h"
#import "YWUser.h"
#import "YWHttptool.h"
#import <NSString+MD5.h>



@interface RegisterController (){
    MBProgressHUD *_hudView;
    
}

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UITextField *password2;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _act;
    self.view.backgroundColor = KviewColor;
    [_phone becomeFirstResponder];
        
}

//获取验证码
- (IBAction)sendMessage:(UIButton *)sender {
    _hudView = [Utils createHUD];
    _hudView.userInteractionEnabled = NO;
    _hudView.labelText = @"正在发送";
    [_hudView hide:YES afterDelay:1];
    YWUser *user = [YWUserTool account];
    
    if ([Utils checkTelNumber:_phone.text]) {
        NSMutableDictionary *paramter = [Utils paramter:Code ID:user.ID];
        paramter[@"ckd"] = [[_type_r dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
        paramter[@"bhphone"] = [[_phone.text dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
        [YWHttptool GET:YWCode parameters:paramter success:^(id responseObject) {
            NSInteger isError = [responseObject[@"isError"] integerValue];
            if (!isError) {
                [Utils timeDecrease:sender];
                 _hudView.mode = MBProgressHUDModeCustomView;
                _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-done"]];
                _hudView.labelText = @"已发送";
                return ;
            }
        } failure:^(NSError *error) {
            _hudView.mode = MBProgressHUDModeCustomView;
            _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hudView.labelText = @"发送失败";
        }];
    }
    else{
         _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"输入的手机号码不合理";
    }
}

//提交账号信息
- (IBAction)sumbit:(UIButton *)sender {
    _hudView = [Utils createHUD];
    _hudView.userInteractionEnabled = NO;
    _hudView.labelText = @"正在提交";
    [_hudView hide:YES afterDelay:1];
    
    if (_phone.text.length == 0) {
        _hudView.labelText = @"请输入手机号码";
        return;
    }
    else if (![Utils checkTelNumber:_phone.text]){
        _hudView.labelText = @"输入的手机号码不合理";
        return;
    }
    else if (![_password1.text isEqualToString:_password2.text]||(_password1.text.length == 0)){
        _hudView.labelText = @"两次输入的密码不一致";
        return;
    }
    else if (_message.text.length == 0){
        _hudView.labelText = @"请输入验证码";
        return;
    }else if (_password1.text.length <6){
        _hudView.labelText = @"请至少输入六位长度的密码";
        return;
    }
    
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:Edit2 ID:user.ID];
    paramter[@"bhcode"] = [[_message.text dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    paramter[@"bhlpwd"] = [_password1.text MD5Digest];
    paramter[@"pkd"] = [[_type_r dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWEdit2 parameters:paramter success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            _hudView.mode = MBProgressHUDModeCustomView;
            _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-done"]];
            _hudView.labelText = @"修改成功";
            
            YWUser *user = [YWUser yw_objectWithKeyValues:responseObject[@"result"]];
            [YWUserTool saveAccount:user];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            _hudView.mode = MBProgressHUDModeCustomView;
            _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hudView.labelText = responseObject[@"errorMessage"];
        }
    } failure:^(NSError *error) {
         _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"发送失败";
    }];
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
