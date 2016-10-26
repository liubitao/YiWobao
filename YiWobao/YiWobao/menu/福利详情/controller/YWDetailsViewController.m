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
#import "YWGoods.h"
#import "YWClaim.h"
#import "YWCover.h"
#import "YWPopView.h"
#import "YWClaimListViewController.h"
#import "YWCodeViewController.h"

@interface YWDetailsViewController ()<UIWebViewDelegate,YWClaimDelegate,YWCoverDelegate>
{
    UIWebView *_webView;
    CGFloat height;
    YWCover *cover;
    YWPopView *menu;
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
    
    CGRect detailSize = [_welfare.title boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:23]}context:nil];
    
    CGFloat W_height = detailSize.size.height+387+64;
    
    if ([Utils isNull:_welfare.claimArray]) {
        W_height = detailSize.size.height+357+64;
    }
    _webView.scrollView.contentInset = UIEdgeInsetsMake(W_height, 0, 0, 0);
    details_view = [[YWdetails alloc]init];
    [[NSBundle mainBundle] loadNibNamed:@"YWdetails" owner:details_view options:nil];
    [details_view setModel:_welfare];
    
    __weak typeof(self) weakSelf = self;
    
    details_view.details_view.frame = CGRectMake(0, -W_height+64, kScreenWidth, W_height-64);
    details_view.userInteractionEnabled = YES;
    [_webView.scrollView addSubview:details_view.details_view];
    
    [details_view pushClaim:^{
        YWClaimListViewController *claimListVC = [[YWClaimListViewController alloc]init];
        claimListVC.welfare = weakSelf.welfare;
        [weakSelf.navigationController pushViewController:claimListVC animated:YES];
    }];
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(0, KscreenHeight-46, kScreenWidth, 46)];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [submit setBackgroundColor:[UIColor redColor]];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    
    if ([_welfare.isback isEqualToString:@"1"]) {
         [submit setTitle:@"申请回购" forState:UIControlStateNormal];
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
    
    
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.5
                                     animations:^{
                                         menu.transform = CGAffineTransformMakeTranslation(0,(KscreenHeight-330)/2- height);
                                     }];
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification{
    height = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         menu.transform = CGAffineTransformIdentity;
                     }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _webView.hidden = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)submit:(UIButton *)sender{
    switch (sender.tag) {
        case 1://回购
        {   if ([Utils isNull:self.welfare.claimArray]) {
                [UIAlertController showAlertViewWithTitle:nil Message:@"您还没有认购过...暂不能回购" BtnTitles:@[@"知道了"] ClickBtn:nil];
                return;
            }
            YWClaimListViewController *claimListVC = [[YWClaimListViewController alloc]init];
            claimListVC.welfare = self.welfare;
            [self.navigationController pushViewController:claimListVC animated:YES];
        }
            break;
        case 2://结束
            break;
        case 3://我要认领
            if ([_welfare.isgd isEqualToString:@"1"]) {
                [self pushGoods:_welfare.goodsid];
            }else{
                cover = [YWCover show];
                [cover setDimBackground:YES];
                cover.alpha = 0.8;
                cover.delegate =self;
                
                // 弹出pop菜单
                CGFloat popX = 30;
                CGFloat popH = 330;
                CGFloat popY = (KscreenHeight-height-330)/2;
                menu = [YWPopView showInRect:CGRectMake(popX, KscreenHeight, kScreenWidth-60, popH)];
                YWClaim *claim = [[YWClaim alloc]initWithFrame:CGRectMake(0,0, kScreenWidth-60,330)];

                claim.welfare = _welfare;
                claim.delegate = self;
                menu.contentView = claim;
                [UIView animateWithDuration:0.5
                                                 animations:^{
                                                     menu.frame = CGRectMake(popX , popY, kScreenWidth-60, popH);
                                                 }];
            }
            break;
        default:
            break;
    }
}

//点击蒙版的时候调用
- (void)coverDidClickCover:(YWCover *)cover{
    for (UIView *popMenu in YWKeyWindow.subviews) {
        if ([popMenu isKindOfClass:[YWPopView class]]) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 popMenu.transform = CGAffineTransformMakeTranslation(0, height+(KscreenHeight-height-330)/2+popMenu.height);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [popMenu removeFromSuperview];
                                 }
                             }];
        }
    }
}

- (void)hide{
    [cover removeFromSuperview];
    for (UIView *popMenu in YWKeyWindow.subviews) {
        if ([popMenu isKindOfClass:[YWPopView class]]) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 popMenu.transform = CGAffineTransformMakeTranslation(0, height+popMenu.height);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [popMenu removeFromSuperview];
                                 }
                             }];
        }
    }
}

//认领
- (void)submit:(NSString *)number name:(NSString *)name phone:(NSString*)phone memo:(NSString *)memo{
    if([number isEqualToString:@"0"]||![Utils checkTelNumber:phone]||[Utils isNull:name]){
        [UIAlertController showAlertViewWithTitle:@"提醒" Message:@"您输入的认领详情有误" BtnTitles:@[@"知道了"] ClickBtn:nil];
        return;
    }
    [cover removeFromSuperview];
    for (UIView *popMenu in YWKeyWindow.subviews) {
        if ([popMenu isKindOfClass:[YWPopView class]]) {
            [popMenu removeFromSuperview];
        }
    }
    
    YWCodeViewController *codeVC = [[YWCodeViewController alloc]init];
    codeVC.type = @"buy_proj";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"zcxmid"] = _welfare.ID;
    dict[@"sprice"] = number;
    dict[@"username"] = name;
    dict[@"pkd"] = @"0";
    dict[@"phone"] = phone;
    dict[@"omeno"] = memo;
    codeVC.buyDic = dict;
    [self presentViewController:codeVC animated:YES completion:nil];

}



- (void)pushGoods:(NSString *)number{
    [MBProgressHUD showMessage:@"加载中" toView:_webView];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[goodsDetails MD5Digest],sKey]MD5Digest];
    parameter[@"gid"] = [[number dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool Post:YWgoodsDetail parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:_webView animated:YES];
        YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
        goodsVC.Goods = [YWGoods yw_objectWithKeyValues:responseObject[@"result"]];
        [self.navigationController pushViewController:goodsVC animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_webView animated:YES];
        [MBProgressHUD showError:@"请求失败" toView:_webView];
    }];
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
