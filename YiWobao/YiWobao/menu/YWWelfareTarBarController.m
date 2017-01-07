//
//  YWWelfareTarBarController.m
//  YiWobao
//
//  Created by 刘毕涛 on 2017/1/4.
//  Copyright © 2017年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWWelfareTarBarController.h"
#import "YWGuideViewController.h"
#import "YWClaimListViewController.h"
#import "YWshoppingController.h"
#import "YWnaviViewController.h"

@interface YWWelfareTarBarController ()<UITabBarControllerDelegate>

@end

@implementation YWWelfareTarBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self setup];
}

- (void)setup{
    YWshoppingController *homeNavi = [[YWshoppingController alloc]init];
    homeNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"商城首页" image:[UIImage imageNamed:@"tabbarShopping"] selectedImage:[UIImage imageWithOriginalName:@"tabbarShoppingsel"]];
    [homeNavi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :KthemeColor} forState:UIControlStateSelected];
    
    YWGuideViewController *knowVC = [[YWGuideViewController alloc]init];
    UINavigationController *knowNavi = [[UINavigationController alloc]initWithRootViewController:knowVC];
    knowNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"福利首页" image:[UIImage imageNamed:@"tabbarList"] selectedImage:[UIImage imageWithOriginalName:@"tabbarListsel"]];
    [knowNavi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :KthemeColor} forState:UIControlStateSelected];
    
    YWClaimListViewController *appearVC = [[YWClaimListViewController alloc]init];
    UINavigationController *appearNavi = [[UINavigationController alloc]initWithRootViewController:appearVC];
    appearNavi.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的福利" image:[UIImage imageNamed:@"tabbarMy"] selectedImage:[UIImage imageWithOriginalName:@"tabbarMysel"]];
    [appearNavi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :KthemeColor} forState:UIControlStateSelected];
    
    self.viewControllers = @[homeNavi,knowNavi,appearNavi];
    self.selectedIndex = 1;
}

- (void)pushOtherIndex:(NSInteger)index viewController:(UIViewController *)VC{
    UINavigationController *oldNavigationController = [self.viewControllers objectAtIndex:self.selectedIndex];
    
    for (NSInteger i = [oldNavigationController.viewControllers count] - 1; i >= 0; i--) {
        
        UIViewController *viewController = [oldNavigationController.viewControllers objectAtIndex:i];
        
        [oldNavigationController popToViewController:viewController animated:NO];
        
    }
    if (index != self.selectedIndex){
        [self setSelectedIndex:index];
    }
    UINavigationController *newNavigationController = [self.viewControllers objectAtIndex:index];
    UIViewController *viewControllerOrgin = newNavigationController.viewControllers[0];
    viewControllerOrgin.hidesBottomBarWhenPushed = YES;
    [newNavigationController pushViewController:VC animated:YES];
    viewControllerOrgin.hidesBottomBarWhenPushed = NO;
}



- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[YWshoppingController class]]) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        return NO;
    }
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
