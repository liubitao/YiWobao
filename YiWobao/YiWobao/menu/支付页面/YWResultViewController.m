//
//  YWResultViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 2017/1/6.
//  Copyright © 2017年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWResultViewController.h"
#import "YWWelfareTarBarController.h"
@interface YWResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resultMsg;

@end

@implementation YWResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付结果";
    
    _resultMsg.userInteractionEnabled = NO;
    _resultMsg.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _resultMsg.titleLabel.font = [UIFont systemFontOfSize:20];
    _resultMsg.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_resultMsg setTitle:_msgStr forState:UIControlStateNormal];
    
    UIButton *laft_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
    [laft_btn setTitle:@"返回" forState:UIControlStateNormal];
    [laft_btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:laft_btn];
    self.navigationItem.leftBarButtonItem = shareItem;

}
- (void)clickBtn:(id)sender{
    if ([self.secondPre isEqualToString:@"1"]) {
        [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
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
