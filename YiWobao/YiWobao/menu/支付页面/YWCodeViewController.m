//
//  YWCodeViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWCodeViewController.h"
#import "XWPresentOneTransition.h"
#import "YWUserTool.h"
#import "YWUser.h"
#import "Utils.h"
#import "YWHttptool.h"
#import "MBProgressHUD+MJ.h"
#import "YWmainViewController.h"


@interface YWCodeViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) XWPresentOneTransition *interactive;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation YWCodeViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image1= [UIImage imageNamed:@"search_skin_bar_text_background"];;
    UIImage *image2=[image1 stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    _backImage.image = image2;
    
    [_textField becomeFirstResponder];
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)pay:(id)sender {
 
    YWUser *user = [YWUserTool account];
    _buyDic[@"pwd"] = [_textField.text MD5Digest];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_buyDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [MBProgressHUD showMessage:@"正在支付" toView:[[UIApplication sharedApplication] keyWindow]];
    
    if ([self.type isEqualToString:@"shop_dpay"]){
        NSMutableDictionary *parameter = [Utils paramter:shop_dpay ID:user.ID];
        
        _buyDic[@"paypwd"] = [_textField.text MD5Digest];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_buyDic options:NSJSONWritingPrettyPrinted error:nil];
        str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        parameter[@"payarr"] = str;
        [YWHttptool Post:YWshopDpay parameters:parameter success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            NSInteger isError = [responseObject[@"isError"] integerValue];
            if (!isError) {
                YWmainViewController *mainVC = [[YWmainViewController alloc]init];
                [self presentViewController:mainVC animated:YES completion:^{
                    [MBProgressHUD showSuccess:@"支付成功" toView:[[UIApplication sharedApplication] keyWindow]];
                }];
            }
            else{
                [MBProgressHUD showError:responseObject[@"errorMessage"] toView:[[UIApplication sharedApplication] keyWindow]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [MBProgressHUD showError:@"请检查网络" toView:[[UIApplication sharedApplication] keyWindow]];
        }];
        return;
    }
    if ([self.type isEqualToString:@"buy_proj"]) {
       NSMutableDictionary *parameter = [Utils paramter:shop_dpay ID:user.ID];

        _buyDic[@"paypwd"] = [_textField.text MD5Digest];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_buyDic options:NSJSONWritingPrettyPrinted error:nil];
        str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        parameter[@"buyarr"] = str;
        [YWHttptool Post:YWbuyProj parameters:parameter success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            NSInteger isError = [responseObject[@"isError"] integerValue];
            if (!isError) {
                [self dismissViewControllerAnimated:YES completion:nil];
                 [MBProgressHUD showSuccess:@"认领成功" toView:[[UIApplication sharedApplication] keyWindow]];
            }
            else{
                [MBProgressHUD showError:responseObject[@"errorMessage"] toView:[[UIApplication sharedApplication] keyWindow]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [MBProgressHUD showError:@"请检查网络" toView:[[UIApplication sharedApplication] keyWindow]];
        }];
        return;

    }
    if ([self.type isEqualToString:@"transfer"]) {
        NSMutableDictionary *paramters = [Utils paramter:Trans ID:user.ID];
        _buyDic[@"tpaypwd"] = [_textField.text MD5Digest];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_buyDic options:NSJSONWritingPrettyPrinted error:nil];
        str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        paramters[@"transarr"] = str;
        
        [YWHttptool Post:YWTrans parameters:paramters success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            NSInteger isError = [responseObject[@"isError"] integerValue];
            if (!isError) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD showSuccess:@"转账成功" toView:[[UIApplication sharedApplication] keyWindow]];
            }
            else{
                [MBProgressHUD showError:responseObject[@"errorMessage"] toView:[[UIApplication sharedApplication] keyWindow]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [MBProgressHUD showError:@"请检查网络" toView:[[UIApplication sharedApplication] keyWindow]];
        }];

        return;
    }
    if ([Utils isNull:_buyDic[@"gid"]]) {
        NSMutableDictionary *paramters = [Utils paramter:do_order ID:user.ID];
        paramters[@"payarr"] = str;
        [YWHttptool Post:YWDoOrder parameters:paramters success:^(id responseObject) {
            NSInteger isError = [responseObject[@"isError"] integerValue];
              [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            if (!isError){
                YWmainViewController *mainVC = [[YWmainViewController alloc]init];
                [self presentViewController:mainVC animated:YES completion:^{
                    [MBProgressHUD showSuccess:@"代付成功" toView:[[UIApplication sharedApplication] keyWindow]];
                }];
            }
            else{
                [MBProgressHUD showError:responseObject[@"errorMessage"] toView:[[UIApplication sharedApplication] keyWindow]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [MBProgressHUD showError:@"请检查网络" toView:[[UIApplication sharedApplication] keyWindow]];
        }];
        return;

    }
    
    else{
        NSMutableDictionary *paramters = [Utils paramter:Goods_order ID:user.ID];
        paramters[@"buyarr"] = str;
    [YWHttptool Post:YWGoodsOrder parameters:paramters success:^(id responseObject) {
         NSInteger isError = [responseObject[@"isError"] integerValue];
          [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
         if (!isError){
             [self presentViewController:[[YWmainViewController alloc]init] animated:YES completion:^{
                 if ([_buyDic[@"pkd"] isEqualToString:@"0"]) {
                    [MBProgressHUD showSuccess:@"支付成功" toView:[[UIApplication sharedApplication] keyWindow]];
                 }else{
                    [MBProgressHUD showSuccess:@"等待代付" toView:[[UIApplication sharedApplication] keyWindow]];
                 }
             }];
         }
         else{
             [MBProgressHUD showError:responseObject[@"errorMessage"] toView:[[UIApplication sharedApplication] keyWindow]];
         }
     } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
         [MBProgressHUD showError:@"请检查网络" toView:[[UIApplication sharedApplication] keyWindow]];
     }];
    }

}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [XWPresentOneTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [XWPresentOneTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    [_textField resignFirstResponder];
    
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
