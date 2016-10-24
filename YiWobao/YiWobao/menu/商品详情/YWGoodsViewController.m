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
#import "YWLoginViewController.h"
#import "YWnaviViewController.h"
#import "SFTrainsitionAnimate.h"
#import "UIViewController+SFTrainsitionExtension.h"

#define NAVBAR_CHANGE_POINT -300

@interface YWGoodsViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate>
{
    UIWebView *_webView;
}

@property (strong, nonatomic) SFTrainsitionAnimate    *animate;

@end

@implementation YWGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    self.title = @"商品详情";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KscreenHeight-50)];
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_webView];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(425.0*kScreenWidth/375, 0, 0, 0);
    _webView.backgroundColor = KviewColor;
    _webView.opaque = NO;
    
    UIView *view = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:-425 width:375 height:425]];
    view.backgroundColor = [UIColor clearColor];
    [_webView.scrollView addSubview:view];
    _webView.scrollView.delegate = self;
    
    UIImageView *pic_view = [[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:0 width:375 height:287]];
    NSString *pic_str = [NSString stringWithFormat:@"%@%@",YWpic,_Goods.pic];
    [pic_view sd_setImageWithURL:[NSURL URLWithString:pic_str] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [view addSubview:pic_view];
    self.sf_targetView = pic_view;
    
    UIView *view2 = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:287 width:375 height:90]];
    view2.backgroundColor = [UIColor whiteColor];
    
    UILabel *name = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:18 width:375-20 height:22]];
    name.textColor = [UIColor blackColor];
    name.font = [UIFont systemFontOfSize:16];
    name.text = _Goods.title;
    [view2 addSubview:name];
    
    UILabel *price = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:45 width:375-20 height:19]];
    price.font = [UIFont systemFontOfSize:18];
    price.textColor = KthemeColor;
    price.width = [Utils labelWidth:[NSString stringWithFormat:@"%@米",_Goods.selprice] font:18 height:100];
    
    UILabel *price2 = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:45 width:100 height:19]];
    price2.left = price.width+20+20;
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@米",_Goods.price]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"717071"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"717071"]}];
    price2.attributedText = attrStr;
    price.text = [NSString stringWithFormat:@"%@米",_Goods.selprice];
    [view2 addSubview:price];
    [view2 addSubview:price2];
    
    UILabel *label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:70 width:375 height:15]];
    label.font = [UIFont systemFontOfSize:12];
    label.text = [NSString stringWithFormat:@"已出售：%@件",_Goods.selnum];
    label.textColor = [UIColor colorWithHexString:@"717071"];
    [view2 addSubview:label];
    [view addSubview:view2];
    
    UILabel *title = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:385 width:375 height:39]];
    title.backgroundColor = [UIColor whiteColor];
    title.text = @"商品详情";
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    
    UIView *line = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:424 width:375 height:1]];
    line.backgroundColor = [UIColor colorWithHexString:@"717071"];
    [view addSubview:line];

    [_webView loadHTMLString:_Goods.descrition baseURL:[NSURL URLWithString:YWpic]];

    //创建购买按钮
    [self create];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.delegate = self;
}

- (SFTrainsitionAnimate *)animate{
    if (!_animate) {
       return [[SFTrainsitionAnimate alloc] initWithAnimateType:animate_pop andDuration:0.5];;
    }
    return _animate;
}

#pragma mark -- navigation delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop && [fromVC isKindOfClass:NSClassFromString(@"YWGoodsViewController")]&&![toVC isKindOfClass:NSClassFromString(@"YWClassViewController")]) {
        return self.animate;
    }else{
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = KthemeColor;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:_webView.scrollView] ;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)create{
    UIButton *buy_button = [[UIButton alloc]initWithFrame:CGRectMake(0, KscreenHeight-50, kScreenWidth, 50)];
    if (![_Goods.selnum isEqualToString:_Goods.num]){
        [buy_button setTitle:@"购买" forState:UIControlStateNormal];
    }else{
        [buy_button setTitle:@"已售罄" forState:UIControlStateNormal];
        buy_button.enabled = NO;
    }
    [buy_button setBackgroundImage:[UIImage imageWithColor:KthemeColor] forState:UIControlStateNormal];
    [buy_button addTarget:self action:@selector(clickBuy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buy_button];
}


- (void)clickBuy:(UIButton *)sender{
    if (![YWUserTool account]) {
        YWLoginViewController *loginVC = [[YWLoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    YWBuyViewController *buyVC = [[YWBuyViewController alloc]init];
    buyVC.goods = _Goods;
    [self.navigationController pushViewController:buyVC animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
