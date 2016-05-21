//
//  YWGoodsViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/20.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWGoodsViewController.h"
#import "YWGoods.h"
#import "YWBuyViewController.h"


@interface YWGoodsViewController ()
{
    UIWebView *_webView;
}

@end

@implementation YWGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = KviewColor;
    self.title = @"商品详情";
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64)];
    [self.view addSubview:scrollView];
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KscreenHeight-64)];
    [scrollView addSubview:_webView];
    
    [_webView loadHTMLString:_Goods.descrition baseURL:nil];
    
    //创建购买按钮
    [self create];
    
    
}

- (void)create{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-50, kScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    UIButton *cancel_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 50)];
    [cancel_button setTitle:@"返回首页" forState:UIControlStateNormal];
    [cancel_button setBackgroundImage:[UIImage imageWithColor:[UIColor cyanColor]] forState:UIControlStateNormal];
    [cancel_button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    cancel_button.alpha = 0.7;
    [view addSubview:cancel_button];
    
    UIButton *buy_button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 50)];
    [buy_button setTitle:@"购买" forState:UIControlStateNormal];
    [buy_button setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]] forState:UIControlStateNormal];
    [buy_button addTarget:self action:@selector(clickBuy:) forControlEvents:UIControlEventTouchUpInside];
    buy_button.alpha = 0.7;
    [view addSubview:buy_button];
    
}

- (void)cancel:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clickBuy:(UIButton *)sender{
    YWBuyViewController *buyVC = [[YWBuyViewController alloc]init];
    
    [self.navigationController pushViewController:buyVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
