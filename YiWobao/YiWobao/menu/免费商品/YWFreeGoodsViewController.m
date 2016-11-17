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
    imageView.contentMode = UIViewContentModeScaleToFill;
    _tableView.tableHeaderView = imageView;
    
    
    if([Utils isNull:_dataArray]){
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, self.view.center.y-50, kScreenWidth, 40);
        label.text = @"您还没有相关的商品";
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"YWgoodsCell" bundle:nil] forCellReuseIdentifier:@"freeGoods"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
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
    [cell setCellModel:self.dataArray[indexPath.section]];
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
    goodsVC.Goods = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
