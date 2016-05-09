//
//  YWnaviViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWnaviViewController.h"
#import "YWmainViewController.h"

@interface YWnaviViewController ()<UITextFieldDelegate>

@end

@implementation YWnaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITextField appearance].delegate = self;
 
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        YWmainViewController *tabarViewController = (YWmainViewController*)self.tabBarController;
        tabarViewController.tabBarView.hidden = YES;
    }
    [super pushViewController:viewController animated:YES];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.childViewControllers.count == 2) {
        YWmainViewController *tabarViewController = (YWmainViewController*)self.tabBarController;
        tabarViewController.tabBarView.hidden = NO;
    }
    return [super popViewControllerAnimated:YES];
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
