//
//  YWDetailsViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/22.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWDetailsViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YWHttptool.h"
#import <NSString+MD5.h>
#import "YWUser.h"
#import "YWUserTool.h"
#import "Utils.h"
#import "YWdetails.h"
#import "YWGoodsViewController.h"
#import "YWClaimListViewController.h"
#import "YWCodeViewController.h"
#import "YWfuliPayViewController.h"

@interface YWDetailsViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    CGFloat height;
    YWdetails *details_view;
}
@end

@implementation YWDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"福利详情";
    self.view.backgroundColor = KviewColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KscreenHeight-46)];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.bounces = NO;
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    [_webView loadHTMLString:_welfare.content baseURL:[NSURL URLWithString:YWpic]];
    [self.view addSubview:_webView];
    _webView.hidden = YES;
    _webView.backgroundColor = KviewColor;
    _webView.delegate = self;
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(350+64, 0, 0, 0);
    details_view = [[YWdetails alloc]init];
    [[NSBundle mainBundle] loadNibNamed:@"YWdetails" owner:details_view options:nil];
    [details_view setModel:_welfare];
    
    details_view.details_view.frame = CGRectMake(0, -350, kScreenWidth, 350);
    [_webView.scrollView addSubview:details_view.details_view];

    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(0, KscreenHeight-46, kScreenWidth, 46)];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [submit setBackgroundColor:[UIColor redColor]];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    
    if ([_welfare.isback isEqualToString:@"1"]) {
         [submit setTitle:@"认领已结束" forState:UIControlStateNormal];
         [submit setBackgroundColor:[UIColor grayColor]];
        submit.tag = 1;
    }else {
        if ([_welfare.stsc isEqualToString:@"0"]||[_welfare.isend isEqualToString:@"1"]||[_welfare.truemoney floatValue]>=[_welfare.totalmoney floatValue]||[_welfare.endtm floatValue]<= time ) {
            [submit setTitle:@"已结束" forState:UIControlStateNormal];
            [submit setBackgroundColor:[UIColor grayColor]];
            submit.tag = 2;
        }else{
            [submit setTitle:@"我要认领" forState:UIControlStateNormal];
            submit.tag = 3;
        }
    }
    
    [self.view addSubview:submit];

}





- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _webView.hidden = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)submit:(UIButton *)sender{
    switch (sender.tag) {
        case 1://回购
            break;
        case 2://结束
            break;
        case 3://我要认领
        {
            YWfuliPayViewController *fuliVC = [[YWfuliPayViewController alloc]init];
            fuliVC.welfare = self.welfare;
            [self hideBottomBarPush:fuliVC];
        }
            break;
        default:
            break;
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.hidesBarsOnSwipe = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

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
