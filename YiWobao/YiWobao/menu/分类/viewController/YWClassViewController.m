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

@interface YWClassViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_leftTable;
    
    UITableView *_rightTable;
    
    CGFloat _leftTableWidth;
    
    NSInteger _leftTableCurRow; //当前被选中的行
}
@end

@implementation YWClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品分类";
    
    _leftTableWidth = 100.f;
    
    _leftTable = [[UITableView alloc] init];
    _leftTable.tableFooterView = [[UIView alloc]init]; //去掉多余的空行分割线
    _leftTable.backgroundColor = KviewColor;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTable];
    [_leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(_leftTableWidth);
        make.height.equalTo(self.view);
    }];
   
    _leftTable.dataSource = self;
    _leftTable.delegate = self;
    _leftTableCurRow = 0;
    
    _rightTable = [[UITableView alloc] init];
    _rightTable.tableFooterView = [[UIView alloc]init]; //去掉多余的空行分割线
    [self.view addSubview:_rightTable];
    [_rightTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTable.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view).with.offset(64);
        make.height.equalTo(self.view);
    }];
    _rightTable.dataSource = self;
    _rightTable.delegate = self;
    
    [self getData];
    //设置选中leftTable的第一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:_leftTable didSelectRowAtIndexPath:indexPath];

}

- (void)getData{
//    [MBProgressHUD showMessage:@"正在加载"];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[Good MD5Digest],sKey]MD5Digest];
//    parameters[@"gkd"] = [[@"1" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
//    [YWHttptool GET:YWGood parameters:parameters success:^(id responseObject) {
//        YWLog(@"%@",responseObject);
//        NSInteger isError = [responseObject[@"isError"] integerValue];
//        [MBProgressHUD hideHUD];
//        if (!isError) {
//           
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"请检查网络"];
//    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int num = 0;
    //leftTable
    if (tableView == _leftTable) {
        num = 1;
    }
    //rightTable
    else if (tableView == _rightTable) {
        num = 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //leftTable
    if (tableView == _leftTable) {
        NSString *identifier = @"leftTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        YWSorts *category = _categories[indexPath.row];
        cell.textLabel.text = category.title;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
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
        YWGoods *product = category.Goods[indexPath.row];
        [cell fillContentWithProduct:product];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    //leftTable
    if (tableView == _leftTable) {
        height = 50;
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
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor whiteColor];
        [_rightTable reloadData];
    }
    //rightTable
    else if (tableView == _rightTable) {
        YWSorts *category = _categories[_leftTableCurRow];
        YWGoods *product = category.Goods[indexPath.row];
        YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
        goodsVC.Goods = product;
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //leftTable
    if (tableView == _leftTable) {
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = KviewColor;
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
