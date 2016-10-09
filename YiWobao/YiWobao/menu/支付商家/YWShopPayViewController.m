//
//  YWShopPayViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWShopPayViewController.h"
#import "Utils.h"
#import "YWPayViewController.h"
#import "YWHttptool.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "MBProgressHUD+MJ.h"
#import "YWShop.h"

@interface YWShopPayViewController ()<UITextFieldDelegate>{
    YWShop *shop;
}
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *iamge;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UIButton *pay_btn;



@end

@implementation YWShopPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _money.delegate = self;
    [self request];
    
}

- (void)request{
    [MBProgressHUD showMessage:@"正在获取数据" toView:self.view];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:shop_pay ID:user.ID];
    paramter[@"smid"] = [[_shopID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWshop_pay parameters:paramter success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError){
            shop = [YWShop yw_objectWithKeyValues:responseObject[@"result"]];
            _titleName.text = [NSString stringWithFormat:@"商户名称:%@",shop.titlename];
            _userName.text = [NSString stringWithFormat:@"商户:%@",shop.username];
            _phone.text = [NSString stringWithFormat:@"电话:%@",shop.phones? shop.phones:@""];
            [_iamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,shop.skewm]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }else{
            [MBProgressHUD showError:@"获取失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请检查网络"];
    }];

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
        _pay_btn.enabled = YES;
    }
    return YES;
    
}


- (IBAction)pay:(id)sender {
    NSMutableDictionary *buyarr = [NSMutableDictionary dictionary];
    buyarr[@"smid"] = _shopID;
    buyarr[@"pje"] = _money.text;
    YWPayViewController *payVC = [[YWPayViewController alloc]init];
    payVC.buyArr = buyarr;
    payVC.total = _money.text;
    if ([shop.ybkind isEqualToString:@"0"]) {
        payVC.yb_can = YES;
    }else {
        payVC.yb_can = NO;
    }
    payVC.type = @"shop_dpay";
    [self presentViewController:payVC animated:YES completion:nil];
   
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
