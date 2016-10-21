//
//  YWViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/6/6.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWViewController.h"
#import "YWgoodsCell.h"
#import "YWSorts.h"
#import "YWBuyViewController.h"
#import "YWGoodsViewController.h"
#import "YWUserTool.h"
#import "YWLoginViewController.h"
#import "YWnaviViewController.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "SFTrainsitionAnimate.h"

@interface YWViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
    UITableView *_tableView;
}
@property (strong, nonatomic) SFTrainsitionAnimate    *animate;
@end

@implementation YWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部商品";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"YWgoodsCell" bundle:nil] forCellReuseIdentifier:@"goodsCell"];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}


- (SFTrainsitionAnimate *)animate{
    if (!_animate) {
        return [[SFTrainsitionAnimate alloc]init];
    }
    return _animate;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush && [toVC isKindOfClass:[YWGoodsViewController class]]) {
        self.navigationController.navigationBarHidden = YES;
        return self.animate;
    }else{
        return nil;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWgoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
    [cell setCellModel:_dataArray[indexPath.row]];
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWgoodsCell *cell = (YWgoodsCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.sf_targetView = cell.picView;
    YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
    goodsVC.Goods = _dataArray[indexPath.row];
    [self.navigationController pushViewController:goodsVC animated:YES];
    
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
