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
#import "YWGoodsViewController.h"
#import "Utils.h"
#import "YWgoodsCell.h"
#import "SFTrainsitionAnimate.h"
#import "YWClassHeader.h"
#import "YWfunctionButton.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "YWClassModel.h"
#import "YWFreeGoodsViewController.h"

@interface YWClassViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *menus;
@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) SFTrainsitionAnimate    *animate;
@end

@implementation YWClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品分类";
    self.view.backgroundColor = [UIColor whiteColor];

    [self request];
    
    //创建商品列表
    [self createTable];
   
    
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"YWgoodsCell" bundle:nil] forCellReuseIdentifier:@"goodsCell"];
}

- (void)request{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[goodscateList MD5Digest],sKey]MD5Digest];
    [YWHttptool GET:YWGoodscateList parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            _menus = [YWClassModel yw_objectWithKeyValuesArray:responseObject[@"result"]];
                YWClassHeader *header = [[YWClassHeader alloc]initWithFrame:({
                    CGRect rect = {0,0,kScreenWidth,300};
                    rect;
                })images:_menus];
                __weak typeof(self) weakSelf = self;
                header.menuBlcok = ^(NSInteger i){
                    YWClassModel *classModel = weakSelf.menus[i];
                    YWFreeGoodsViewController *freeVC = [[YWFreeGoodsViewController alloc]init];
                    freeVC.title = classModel.title;
                    for (YWSorts *sorts in weakSelf.dataArray) {
                        if ([sorts.ID isEqualToString:classModel.ID]) {
                            freeVC.dataArray = sorts.Goods.mutableCopy;
                        }
                    }
                    [weakSelf.navigationController pushViewController:freeVC animated:YES];
                };
                _tableView.tableHeaderView = header;
            
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];

}

//创建商品列表
- (void)createTable{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YWSorts *sorts = _dataArray[section];
    return sorts.Goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWgoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    YWSorts *sorts = _dataArray[indexPath.section];
    [cell setCellModel:sorts.Goods[indexPath.row]];
    cell.indexPath = indexPath;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    YWfunctionButton *button = [[YWfunctionButton alloc]initWithFrame:CGRectMake(17.6, 0, 200, 40)];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    YWSorts *sorts = _dataArray[section];
    [button setTitle:[NSString stringWithFormat:@"  %@",sorts.title] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ic_goods_icon"] forState:UIControlStateNormal];
    [view addSubview:button];
    button.titleLabel.font = [UIFont fontWithName:@"FZLanTingHei-L-GBK" size:16];
    [button setTitleColor:[UIColor colorWithHexString:@"3E3A39"] forState:UIControlStateNormal];
    
    UIButton *more_btn = [[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:330 Y:20 width:35 height:14]];
    more_btn.tag = section;
    [more_btn setImage:[UIImage imageNamed:@"ic_mall_fragment_more"] forState:UIControlStateNormal];
    [more_btn addTarget:self action:@selector(jumpMore:) forControlEvents:UIControlEventTouchUpInside];
    more_btn.tag = section;
    [view addSubview:more_btn];
    return view;
}

- (void)jumpMore:(UIButton *)sender{
    YWFreeGoodsViewController  *freeVC = [[YWFreeGoodsViewController alloc]init];
    YWSorts *sorts = self.dataArray[sender.tag];
    freeVC.dataArray = sorts.Goods.mutableCopy;
    freeVC.title = sorts.title;
    [self.navigationController pushViewController:freeVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWgoodsCell *cell = (YWgoodsCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.sf_targetView = cell.picView;
    
    YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
    YWSorts *sorts = _dataArray[indexPath.section];
    goodsVC.Goods = sorts.Goods[indexPath.row];
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
