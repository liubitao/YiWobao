//
//  YWFreeGoodsViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/10/24.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWFreeGoodsViewController.h"
#import "YWgoodsCell.h"
#import "YWGoodsViewController.h"
#import "UIViewController+SFTrainsitionExtension.h"

@interface YWFreeGoodsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;


@end

@implementation YWFreeGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];

    [self createTableView];
}

- (void)createTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
    imageView.image = [UIImage imageNamed:@"freeImage"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _tableView.tableHeaderView = imageView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"YWgoodsCell" bundle:nil] forCellReuseIdentifier:@"freeGoods"];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sort.Goods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWgoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"freeGoods" forIndexPath:indexPath];
    [cell setCellModel:_sort.Goods[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWgoodsCell *cell = (YWgoodsCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.sf_targetView = cell.picView;
    
    YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
    goodsVC.Goods = _sort.Goods[indexPath.section];
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
