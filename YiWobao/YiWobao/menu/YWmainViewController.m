 //
//  YWmainViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWmainViewController.h"
#import "YWpersonalViewController.h"
#import "YWshoppingController.h"
#import "YWnaviViewController.h"
#import "YWItemView.h"
#import "YWUserTool.h"
#import "YWLoginViewController.h"

@interface YWmainViewController ()
{
    //记录标签栏选中的按钮
    YWItemView *_lastItem;
    
}

@end

@implementation YWmainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给tabbar设置子视图
    [self initViews];
    
    //自定义标签栏
    [self _initCustomView];
    
}

-(void)initViews{
    
    //创建商城视图
    YWshoppingController *shoppingVC = [[YWshoppingController alloc]init];
 
    //创建个人视图
    YWpersonalViewController *personalVC = [[YWpersonalViewController alloc]init];
    
    NSArray *ViewControllers = @[shoppingVC,personalVC];

    //为每个视图添加一个导航控制器
    NSMutableArray *baseNavArr = [NSMutableArray array];

    for (UIViewController *viewController in ViewControllers) {
        YWnaviViewController *naviVC = [[YWnaviViewController alloc]initWithRootViewController:viewController];
        [baseNavArr addObject:naviVC];
    }
    self.viewControllers = baseNavArr;
    
}

-(void)_initCustomView{
    
    // 1.移除系统控件
    self.tabBar.hidden = YES;
    //添加背景图片
    _tabBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KscreenHeight-49, kScreenWidth, 49)];
    _tabBarView.userInteractionEnabled = YES;
    _tabBarView.backgroundColor = [UIColor colorWithHexString:@"3E3A39"];
    [self.view addSubview:_tabBarView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 10, 1, 49-20)];
    line.backgroundColor = [UIColor whiteColor];
    [_tabBarView addSubview:line];
    
    //创建标签控制器上面的按钮
    NSArray *imageNames = @[@"tabbar_home",@"tabbar_profile"];
    NSArray *selectImageNames = @[@"tabbar_home_selected",@"tabbar_profile_selected"];
    NSArray *titles = @[@"蚁窝商城",@"个人中心"];
    float width = kScreenWidth/imageNames.count;
    for (int i = 0 ; i<imageNames.count; i++) {
        YWItemView *itemView = [[YWItemView alloc] initWithFrame:CGRectMake(i*width, 0.f, width, 49.f)];
        itemView.tag = i;
        [itemView setItemImage:imageNames[i] forControlState:UIControlStateNormal];
        [itemView setItemImage:selectImageNames[i] forControlState:UIControlStateSelected];
        [itemView setItemTitle:titles[i] withSpecialTextColor:[UIColor orangeColor]];
        [self.tabBarView addSubview:itemView];
        
        // 增加点击事件
        [itemView addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 绑定tag
        itemView.tag = i;
        if (0 == i) {
            itemView.selected = YES;
            _lastItem = itemView;
        }
    }
}


-(void)buttonAction:(YWItemView *)sender{
    if (sender.tag == _lastItem.tag) return;
    
    //判断登录没有，没有登录就跳转到登录的页面，登录了就正常跳
        if ([YWUserTool account] == nil ) {
            YWnaviViewController *loginVC = [[YWnaviViewController alloc]initWithRootViewController:[[YWLoginViewController alloc]init]];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
        else{
            //取消上一个按钮的选中状态
            _lastItem.selected = NO;
            
            //更新标签栏控制器的索引
            self.selectedIndex = sender.tag;
            
            //更新按钮的状态
            sender.selected = YES;
            
            //再次记录当前选中的按钮
            _lastItem = sender;
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
