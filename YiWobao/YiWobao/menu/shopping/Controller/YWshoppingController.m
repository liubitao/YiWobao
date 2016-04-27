//
//  YWshoppingController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWshoppingController.h"
#import "YWSearchBar.h"
@interface YWshoppingController ()

@end

@implementation YWshoppingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    YWSearchBar *searchBar = [[YWSearchBar alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 35)];
    searchBar.placeholder = @"大家都在搜";
    //设置为导航栏的标题视图
    self.navigationItem.titleView = searchBar;
    
    
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
