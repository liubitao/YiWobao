//
//  YWShopDetailsController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/10/25.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWShopDetailsController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"

@interface YWShopDetailsController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@end

@implementation YWShopDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"店铺详情";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64)];
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    _webView.delegate = self;
    [_webView loadHTMLString:_shop.sdescs baseURL:[NSURL URLWithString:YWpic]];
    [self.view addSubview:_webView];
    
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.bounds), 4)];
    progressView.progressBarColor = KthemeColor;
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    
    // 设置进度条
    self.progressProxy.progressView = progressView;
    // 将UIWebView代理指向YHWebViewProgress
    _webView.delegate = self.progressProxy;
    // 设置webview代理转发到self（可选）
    self.progressProxy.webViewProxy = self;
    
    // 添加到视图
    [self.view addSubview:progressView];
    
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.opaque = NO;
    
    UIView *view = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:-150 width:kScreenWidth height:150]];
    view.backgroundColor = [UIColor clearColor];
    [_webView.scrollView addSubview:view];
    
    NSUserDefaults *defait = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defait objectForKey:@"shops"];
    UILabel *sortLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 50, 20)];
    sortLabel.text = array[[_shop.shcate integerValue]-1];
    sortLabel.font = [UIFont systemFontOfSize:15];
    CGRect detailSize = [sortLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}context:nil];
    NSLog(@"%@",NSStringFromCGSize(detailSize.size));
    sortLabel.width = detailSize.size.width+10;
    sortLabel.textColor = KthemeColor;
    sortLabel.textAlignment = NSTextAlignmentCenter;
    sortLabel.layer.borderColor = KthemeColor.CGColor;
    sortLabel.layer.borderWidth = 1;
    sortLabel.layer.cornerRadius = 3;
    sortLabel.layer.masksToBounds = YES;
    [view addSubview:sortLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(sortLabel.right+10, sortLabel.top, kScreenWidth- sortLabel.right+10, 20)];
    titleLabel.text = _shop.titlename;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:titleLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20, titleLabel.bottom+15, kScreenWidth-40, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    [view addSubview:line1];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom+5, kScreenWidth-40, 17)];
    addressLabel.text = [NSString stringWithFormat:@"地址：%@",_shop.address];
    addressLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:addressLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, addressLabel.bottom+5, addressLabel.width, 17)];
    NSString *str = [NSString stringWithFormat:@"电话：%@",_shop.phones];
    phoneLabel.attributedText = [Utils stringWith:str font1:[UIFont systemFontOfSize:16] color1:[UIColor blackColor] font2:[UIFont systemFontOfSize:16] color2:[UIColor blueColor] range:NSMakeRange(3, _shop.phones.length)];
    [view addSubview:phoneLabel];
    
    
    UILabel *picLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, phoneLabel.bottom+15, 20, 20)];
    picLabel.text = @"营";
    picLabel.textAlignment = NSTextAlignmentCenter;
    picLabel.textColor = [UIColor whiteColor];
    picLabel.backgroundColor = KthemeColor;
    picLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:picLabel];
    
    UILabel *businssLabel = [[UILabel alloc]initWithFrame:CGRectMake(picLabel.right+10, picLabel.top  , kScreenWidth-70, 20)];
    businssLabel.text = _shop.business;
    businssLabel.font = [UIFont systemFontOfSize:16];
    businssLabel.textColor = [UIColor colorWithHexString:@"b3b3b4"];
    [view addSubview:businssLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, businssLabel.bottom+10, kScreenWidth-40, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    [view addSubview:line2];
}

- (void)didReceiveMemoryWarning{
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
