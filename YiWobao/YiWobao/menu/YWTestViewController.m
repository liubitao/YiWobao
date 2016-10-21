//
//  YWTestViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/10/21.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWTestViewController.h"

@interface YWTestViewController ()<UIWebViewDelegate>{
    UIWebView *_webView;
}

@end

@implementation YWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KscreenHeight)];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.bounces = NO;
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.yiwob.com/shop/textindex.php"]]];
    _webView.backgroundColor = KviewColor;
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;{
    NSLog(@"%@",request);
    return YES;
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
