//
//  YWPayViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/11.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWPayViewController.h"
#import "XWPresentOneTransition.h"
#import "YWCodeViewController.h"
#import "YWUser.h"
#import "YWUserTool.h"

@interface YWPayViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) XWPresentOneTransition *interactive;

@property (weak, nonatomic) IBOutlet UILabel *accout;
@property (weak, nonatomic) IBOutlet UIButton *way1;
@property (weak, nonatomic) IBOutlet UIButton *way2;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIButton *yb_btn;

@end

@implementation YWPayViewController


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
    YWUser *user = [YWUserTool account];
    float ID = [user.ID floatValue];
    _buyArr[@"g_c"] = @"1";
    _accout.text = [NSString stringWithFormat:@"%.0f",ID+500000];
    _money.text = _total;
    if (!_yb_can) {
        _yb_btn.hidden = YES;
        _way2.selected = YES;
        _buyArr[@"g_c"] = @"0";
    }
}

//取消
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pay:(UIButton *)sender{
    YWCodeViewController *CodeVC = [[YWCodeViewController alloc]init];
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _buyArr[@"pkd"] = @"0";
    CodeVC.buyDic = _buyArr;
    CodeVC.type = self.type;
    [self presentViewController:CodeVC animated:YES completion:nil];
}
- (IBAction)payWay1:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _way1.selected = YES;
    _way2.selected = NO;
    _buyArr[@"g_c"] = @"1";
}

- (IBAction)payWay2:(UIButton *)sender {
    if (sender.selected){
        return;
    }
    _way2.selected = YES;
    _way1.selected = NO;
     _buyArr[@"g_c"] = @"0";
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [XWPresentOneTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [XWPresentOneTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
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
