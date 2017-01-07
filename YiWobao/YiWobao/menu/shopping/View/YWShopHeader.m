//
//  YWShopHeader.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/10/21.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWShopHeader.h"
#import "YWshopButton.h"
#import "SDCycleScrollView.h"
#import "YWFreeView.h"

@interface YWShopHeader ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) YWFreeView *freeView;

@end


@implementation YWShopHeader



- (SDCycleScrollView*)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150) shouldInfiniteLoop:YES imageNamesGroup:self.imageArray];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _cycleScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)images{
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray = images;
        [self setup];
    }
    return self;
}

- (void)setup{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    [self addSubview:self.cycleScrollView];

    CGFloat itemWidth = kScreenWidth/4;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView.bottom, kScreenWidth, 120)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"免费商品",@"蚁窝商城",@"联盟商家",@"福利认领"];
    NSArray *images = @[@"topnav-9",
                        @"topnav-10",
                        @"topnav-11",
                        @"topnav-12"];
    
    for (NSInteger i = 0; i<4; i++) {
        YWshopButton *button = [[YWshopButton alloc]initWithFrame:CGRectMake(i*itemWidth, 20, itemWidth, 80)];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    [self addSubview:view];
    
    _freeView = [[YWFreeView alloc]initWithFrame:CGRectMake(0, view.bottom+10,kScreenWidth , 1)];
    __weak typeof(self) weakSelf = self;
    _freeView.FreeBlcok = ^(NSInteger index){
        if (weakSelf.middleBlcok) {
            weakSelf.middleBlcok(index);
        }
    };
    _freeView.heightBlcok = ^(CGFloat height){
        if (weakSelf.heightBlcok) {
            weakSelf.heightBlcok(height);
        }
    };
    _freeView.clickBlcok = ^(){
        if (weakSelf.middleClick) {
            weakSelf.middleClick();
        }
    };
    
    [self addSubview:_freeView];
    
    self.height = _freeView.bottom+10;
}

- (void)clickBtn:(YWshopButton *)sender{
    if (_menuBlcok){
        _menuBlcok(sender.tag);
    }
}

- (void)setImages:(NSMutableArray *)images{
    for (int i = 0; i<self.subviews.count; i++) {
        if ([self.subviews[i] isKindOfClass:[SDCycleScrollView class]]) {
            [self.subviews[i] removeFromSuperview];
        }
    }
    _imageArray = images;
    [self addSubview:self.cycleScrollView];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击图片");
}

@end

@interface YWFreeView ()<UIWebViewDelegate>{
    UIWebView *_webView;
    BOOL first;
}

@end
@implementation YWFreeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 30)];
    titleLabel.text = @"免费商品";
    titleLabel.textColor = KthemeColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 5, 40, 30)];
    [moreButton setImage:[UIImage imageNamed:@"ic_mall_fragment_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreButton];
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, kScreenWidth, 1)];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.bounces = NO;
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:YWFreeGoods]]];
    _webView.backgroundColor = KviewColor;
    _webView.delegate = self;
    [self addSubview:_webView];
}

- (void)clickMore:(UIButton *)sender{
    if (_clickBlcok){
        _clickBlcok();
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat str = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
    _webView.height = str+10;
    self.height = _webView.bottom;
    if (_heightBlcok) {
        _heightBlcok(_webView.height);
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    NSLog(@"加载失败");
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;{
    if (!first) {
        first = YES;
        return YES;
    }
    NSLog(@"%@",request.URL);
    // 拿到网页上的请求地址
    NSString *URLString = [NSString stringWithFormat:@"%@",request.URL.absoluteString];
    // 判断网页的请求地址协议是否是我们自定义的那个
    NSRange range = [URLString rangeOfString:@"="];
    if (range.length == 0) {
        return NO;
    }
    NSString *str = [URLString substringFromIndex:range.location+1];
    if (_FreeBlcok){
        _FreeBlcok(str.integerValue);
    }
    return NO;
}

@end

