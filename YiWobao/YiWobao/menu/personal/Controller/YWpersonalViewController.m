//
//  YWpersonalViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWpersonalViewController.h"
#import "YlListButton.h"

@interface YWpersonalViewController ()

@end

@implementation YWpersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    //创建上面的视图
    [self createHead];
    
}

-(void)createHead{
    YlListButton *leftbutton = [YlListButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(30, 30, 60, 30);
    [leftbutton setTitle:@"推荐人" forState:UIControlStateNormal];
    [leftbutton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    [leftbutton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateSelected];
    //高亮的时候不用变化图片
    leftbutton.adjustsImageWhenHighlighted = NO;
    
    [leftbutton addTarget:self  action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftbutton];
}

-(void)leftClick:(YlListButton *)sender{
    sender.selected = !sender.selected;
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
