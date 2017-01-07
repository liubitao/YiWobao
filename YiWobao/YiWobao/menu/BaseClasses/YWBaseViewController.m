//
//  YWBaseViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWBaseViewController.h"
#import "YWLoginViewController.h"
#import <UMSocial.h>
#import "SearchViewController.h"

@interface YWBaseViewController ()<UISearchBarDelegate,UMSocialUIDelegate>

@end

@implementation YWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KviewColor;
}

- (void)pushController:(UIViewController *)controller {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)hideBottomBarPush:(UIViewController *)controller {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initNavi{
    NSString *str;
  
     if ([self isKindOfClass:NSClassFromString(@"YWshoppingController")]){
        str = @"大家都在搜";
    }
    else {
        str = @"请输入商户关键词";
    }

    UISearchBar* searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 35)];
    searchBar.placeholder = str;
    searchBar.returnKeyType = UIReturnKeyGo;
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = 10;
    searchBar.layer.masksToBounds = YES;
    for (UIView *view in searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    //设置为导航栏的标题视图
    self.navigationItem.titleView = searchBar;
    
    UIButton *right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [right_btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [right_btn addTarget:self action:@selector(shared) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:right_btn];
    self.navigationItem.rightBarButtonItem = shareItem;

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

- (void)shared{
    YWUser *user = [YWUserTool account];
    if ([Utils isNull:user]) {
        YWLoginViewController *loginVC = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    NSMutableDictionary *parameters = [Utils paramter:Share ID:user.ID];
    [YWHttptool   GET:YWShare parameters:parameters success:^(id responseObject) {
        UIImage *image = [UIImage imageNamed:@"app"];
        NSString *str = responseObject[@"result"][@"saddr"];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = str;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = str;
        //调用快速分享接口
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"574cf23967e58e27de0001da"
                                          shareText:@"蚁窝宝希望您的参与。"                                                                     shareImage:image
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                           delegate:self];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [MBProgressHUD showSuccess:@"分享成功"];
    }
    else{
        [MBProgressHUD showError:@"分享失败"];
    }
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
