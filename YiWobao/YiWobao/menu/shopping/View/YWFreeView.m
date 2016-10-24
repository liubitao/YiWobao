////
////  YWFreeView.m
////  YiWobao
////
////  Created by 刘毕涛 on 16/10/24.
////  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
////
//
//#import "YWFreeView.h"
//@interface YWFreeView ()<UIWebViewDelegate>{
//    UIWebView *_webView;
//}
//
//@end
//@implementation YWFreeView
//
//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}
//
//- (void)setup{
//    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KscreenHeight)];
//    _webView.scrollView.backgroundColor = [UIColor whiteColor];
//    _webView.scrollView.bounces = NO;
//    _webView.contentMode = UIViewContentModeScaleAspectFit;
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.yiwob.com/shop/textindex.php"]]];
//    
//    _webView.backgroundColor = KviewColor;
//    _webView.delegate = self;
//    [self addSubview:_webView];
//}
//
//
//@end
