//
//  YWClassViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/21.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWClassViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YWHttptool.h"
#import "YWSorts.h"
#import "YWGoods.h"
#import "TabHomeRightTableCell.h"
#import "YWGoodsViewController.h"
#import "Utils.h"
#import "MBProgressHUD+MJ.h"

@interface YWClassViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_leftTable;
    
    UITableView *_rightTable;
    
    CGFloat _leftTableWidth;
}
@end

@implementation YWClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品分类";
    self.view.backgroundColor = KviewColor;
    
    _leftTableWidth = 80.f;
    
    _leftTable =  [[UITableView alloc] init];

    _leftTable.backgroundColor = [UIColor clearColor];
    [_leftTable setSeparatorInset:UIEdgeInsetsZero];
    [_leftTable setLayoutMargins:UIEdgeInsetsZero];
    _leftTable.bounces = NO;
    [self.view addSubview:_leftTable];
    _leftTable.frame = CGRectMake(0, 35, _leftTableWidth, KscreenHeight-64-35);
    
    _leftTable.dataSource = self;
    _leftTable.delegate = self;
    
    _rightTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _rightTable.tableFooterView = [[UIView alloc]init]; //去掉多余的空行分割线
    _rightTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_rightTable];
    _rightTable.frame = CGRectMake(90, 40, kScreenWidth-100, KscreenHeight-64-20);
    _rightTable.dataSource = self;
    _rightTable.delegate = self;
    
    if (![Utils isNull:_categories]) {
        //设置选中leftTable的第一行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_leftTableCurRow inSection:0];
        [_leftTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self tableView:_leftTable didSelectRowAtIndexPath:indexPath];
    }else{
        [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num = 0;
    //leftTable
    if (tableView == _leftTable) {
        num = 1;
    }
    //rightTable
    else if (tableView == _rightTable) {
        if (_categories && _categories.count > 0) {
            YWSorts *category = _categories[_leftTableCurRow];
            num = category.Goods.count;
        }else{
            UILabel *label = [[UILabel alloc]init];
            [_rightTable addSubview:label];
            [_rightTable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_rightTable);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(50);
            }];
            label.text = @"暂时还没有添加该类的商品";
            label.font = [UIFont systemFontOfSize:20];
        }
    }
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    //leftTable
    if (tableView == _leftTable) {
        if (_categories && _categories.count > 0) {
            num = _categories.count;
        }
    }
    //rightTable
    else if (tableView == _rightTable) {
        num = 1;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_leftTable == tableView) {
        return 0.5;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_leftTable == tableView) {
        return 0.5;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //leftTable
    if (tableView == _leftTable) {
        NSString *identifier = @"leftTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setLayoutMargins:UIEdgeInsetsZero];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.center = cell.center;
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(79.5, 0, 0.5, 43.5)];
            view.backgroundColor = [UIColor colorWithHexString:@"B4B5B5" withAlpha:0.5];
            view.tag = 1;
            [cell.contentView addSubview:view];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 43.5)];
            label.font = [UIFont systemFontOfSize:16];
            label.tag = 2;
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
        }
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:2];
        YWSorts *category = _categories[indexPath.row];
        label.text = category.title;
        if (indexPath.row == _leftTableCurRow) {
            label.textColor = KthemeColor;
            cell.backgroundColor = [UIColor clearColor];
            [cell.contentView viewWithTag:1].hidden = YES;
        }
        return cell;
    }
    //rightTable
    else {
        NSString *identifier = @"rightTableCell";
        TabHomeRightTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[TabHomeRightTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        YWSorts *category = _categories[_leftTableCurRow];
        YWGoods *product = category.Goods[indexPath.section];
        [cell fillContentWithProduct:product];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    //leftTable
    if (tableView == _leftTable) {
        height = 43.5;
    }
    //rightTable
    else if (tableView == _rightTable) {
        height = [TabHomeRightTableCell height];
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //leftTable，更新rightTable的数据
    if (tableView == _leftTable) {
        
        _leftTableCurRow = indexPath.row;
        UILabel *label = (UILabel*)[[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:2];
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
        label.textColor = KthemeColor;
        [[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1].hidden = YES;
        
        [_rightTable reloadData];
    }
    //rightTable
    else if (tableView == _rightTable) {
        YWSorts *category = _categories[_leftTableCurRow];
        YWGoods *product = category.Goods[indexPath.section];
        YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
        goodsVC.Goods = product;
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
{
    //leftTable
    if (tableView == _leftTable) {
       
        UILabel *label = (UILabel*)[[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:2];
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        [[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1].hidden = NO;
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
