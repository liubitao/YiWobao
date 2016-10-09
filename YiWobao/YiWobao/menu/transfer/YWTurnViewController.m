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
#import "YWCodeViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RegisterController.h"


#define kRequestTime 3.0f
#define kDelay 1.0f

@interface YWTurnViewController ()<UITextFieldDelegate>
{
    BOOL _wasKeyboardManagerEnabled;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITextField *money_text;
@property (weak, nonatomic) IBOutlet UIButton *transfer2;

@property (weak, nonatomic) IBOutlet UIButton *transfer1;


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
    _money_text.delegate = self;
    
    YWUser *user = [YWUserTool account];
    NSLog(@"%@",user.transkind);
    if ([user.transkind isEqualToString:@"1"]) {
        _transfer2.hidden = YES;
    }else if ([user.transkind isEqualToString:@"2"]){
        _transfer1.hidden = YES;
    }
    _transfer1.enabled = NO;
    _transfer2.enabled = NO;
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
    if (![Utils isNull:textField.text]) {
        _transfer1.enabled = YES;
        _transfer2.enabled = YES;
    }
    return YES;
    
}


- (IBAction)turnMoney:(id)sender {
    [self transfer:@"0"];
 
}
- (IBAction)transfer2:(UIButton *)sender {
    [self transfer:@"1"];
}

- (void)transfer:(NSString *)kind{
    YWCodeViewController *codeVC = [[YWCodeViewController alloc]init];
    codeVC.type = @"transfer";
    NSMutableDictionary *transDic = [NSMutableDictionary dictionary];
    transDic[@"tbh"] = self.user.ID;
    transDic[@"tje"] = self.money_text.text;
    transDic[@"zzkind"] = kind;
    codeVC.buyDic = transDic;
    [self presentViewController:codeVC animated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
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
