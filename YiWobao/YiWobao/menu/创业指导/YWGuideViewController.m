//
//  YWGuideViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/7/14.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWGuideViewController.h"
#import "MBProgressHUD+MJ.h"

@interface YWGuideViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation YWGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mp.weixin.qq.com/s?__biz=MzAxNDc4MzU1OA==&mid=404644572&idx=1&sn=7a62b439229e6ea4149844df23461199&scene=0&previewkey=d27%2BRv0szrpW5UlZ%2FHHw9cwqSljwj2bfCUaCyDofEow%3D#wechat_redirect"]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessage:@"正在加载..." toView:_webView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:_webView animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [MBProgressHUD hideHUDForView:_webView animated:YES];
    [MBProgressHUD showError:@"请检查网络..." toView:_webView];
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
