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
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "YWHttptool.h"


@interface YWGoodsViewController ()
{
    UIWebView *_webView;
}
@end

@implementation YWGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    self.title = @"商品详情";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64-50)];
    [self.view addSubview:_webView];
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(260, 0, 0, 0);
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.opaque = NO;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, -260, kScreenWidth, 260)];
    view.backgroundColor = [UIColor clearColor];
    [_webView.scrollView addSubview:view];
    
    UIImageView *pic_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    NSString *pic_str = [NSString stringWithFormat:@"%@%@",YWpic,_Goods.pic];
    [pic_view sd_setImageWithURL:[NSURL URLWithString:pic_str] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [view addSubview:pic_view];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 60)];
    view2.backgroundColor = [UIColor redColor];
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
    price.font = [UIFont systemFontOfSize:30];
    price.textColor = [UIColor whiteColor];
    UILabel *price2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-220, 0, 200, 40)];
    price2.textAlignment = NSTextAlignmentRight;
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:_Goods.price
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20.f],
       NSForegroundColorAttributeName:[UIColor whiteColor],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor whiteColor]}];
    price2.attributedText = attrStr;
    price.text = _Goods.selprice;
    [view2 addSubview:price];
    [view2 addSubview:price2];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, kScreenWidth, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = [NSString stringWithFormat:@"已出售：%@",_Goods.selnum];
    label.textColor = [UIColor whiteColor];
    [view2 addSubview:label];
    [view addSubview:view2];
    
    
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
    buyVC.goods = _Goods;
    [self.navigationController pushViewController:buyVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
