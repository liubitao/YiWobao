//
//  YWshoppingController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWshoppingController.h"
#import "YWSearchBar.h"
#import "YWHttptool.h"
#import "YWGoods.h"
#import "YWSorts.h"
#import "YWgoodsCell.h"
#import "Utils.h"
#import "SearchViewController.h"
#import "YWGoodsViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YWBuyViewController.h"
#import "YWClassViewController.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "YWViewController.h"
#import "YWLoginViewController.h"
#import "YWnaviViewController.h"
#import "YWGuideViewController.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "SFTrainsitionAnimate.h"
#import "YWScanViewController.h"
#import "YWmainItemButton.h"
#import "YWfunctionButton.h"
#import "YWFederalViewController.h"
#import "YWTestViewController.h"
#import "YWShopHeader.h"


@interface YWshoppingController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
    UISearchBar *searchBar;
    UITableView *_tableView;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray;
    int inter;
}
@property (strong, nonatomic) SFTrainsitionAnimate    *animate;

@end

@implementation YWshoppingController

- (void)viewDidLoad {
    [super viewDidLoad];
    inter=0;
    self.title = @"商城";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    
    [self initNavi];
    
    //创建商品列表
    [self createTable];
    
    
    // 注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"YWgoodsCell" bundle:nil] forCellReuseIdentifier:@"goodsCell"];
    
}

- (void)initNavi{
    [super initNavi];
    
    UIButton *left_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [left_btn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [left_btn addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBrt = [[UIBarButtonItem alloc]initWithCustomView:left_btn];
    self.navigationItem.leftBarButtonItem = leftBrt;
    
}

//二维码扫描
- (void)scan{
    YWScanViewController *scanVC = [[YWScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
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
//商品图片动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush && [toVC isKindOfClass:[YWGoodsViewController class]]) {
        self.navigationController.navigationBarHidden = YES;
        return self.animate;
    }else{
        return nil;
    }
    
}

//创建商品列表
- (void)createTable{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64-49) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    NSMutableArray  *images = [NSMutableArray arrayWithArray: @[@"show1",@"show2",@"show3"]];
    YWShopHeader *header = [[YWShopHeader alloc]initWithFrame:({
        CGRect rect = {0,0,kScreenWidth,0};
            rect;
    })images:images];
    header.menuBlcok = ^(NSInteger i){
        switch (i) {
            case 0:{
                NSLog(@"免费商品");
                YWTestViewController *testVC = [[YWTestViewController alloc]init];
                [self.navigationController pushViewController:testVC animated:YES];
            }
                break;
            case 1:{
                YWClassViewController *classVC = [[YWClassViewController alloc]init];
                classVC.categories = _dataArray;
                classVC.leftTableCurRow = 0;
                [self.navigationController pushViewController:classVC animated:YES];
            }
                break;
            case 2:
            {
                YWFederalViewController *FederalVC = [[YWFederalViewController alloc]init];
                [self.navigationController pushViewController:FederalVC animated:YES];
            }
                break;
            case 3:
            {
                if (![YWUserTool account]) {
                    YWLoginViewController *loginVC = [[YWLoginViewController alloc]init];
                    [self presentViewController:loginVC animated:YES completion:nil];
                    return;
                }
                YWGuideViewController *VC = [[YWGuideViewController alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            default:
                break;
        }
    };
    _tableView.tableHeaderView = header;
    
    [self request];
    
}

- (void)request{
    [MBProgressHUD hideHUDForView:_tableView animated:YES];
    [MBProgressHUD showMessage:@"正在加载" toView:_tableView];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[Good MD5Digest],sKey]MD5Digest];
    parameters[@"gkd"] = [[@"0" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWGood parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger isError = [responseObject[@"isError"] integerValue];
        [MBProgressHUD hideHUDForView:_tableView];
        if (!isError) {
            [_dataArray removeAllObjects];
            NSMutableArray *array = [YWSorts yw_objectWithKeyValuesArray:responseObject[@"result"]];
            for (YWSorts *sorts in array) {
                if (![Utils isNull:sorts.Goods]) {
                    [_dataArray addObject:sorts];
                }
            }
            _dataArray1 = [NSMutableArray arrayWithArray:_dataArray];
            NSMutableArray *isfree_array = [NSMutableArray array];
            for (YWSorts *sort in _dataArray) {
                for (YWGoods *goods in sort.Goods) {
                    if ([goods.isfree isEqualToString:@"1"]) {
                        [isfree_array addObject:goods];
                    }
                }
            }
            
            YWSorts *sort = [[YWSorts alloc]init];
            if (![Utils isNull:isfree_array]) {
                sort.Goods = isfree_array;
                sort.title = @"免费";
                [_dataArray insertObject:sort atIndex:0];
            }
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_tableView];
        [MBProgressHUD showError:@"请检查网络" toView:_tableView];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YWSorts *sorts = _dataArray[section];
    if (sorts.Goods.count<2) {
        return sorts.Goods.count;
    }
    return 2;
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
    [more_btn setImage:[UIImage imageNamed:@"ic_mall_fragment_more"] forState:UIControlStateNormal];
    [more_btn addTarget:self action:@selector(jumpMore:) forControlEvents:UIControlEventTouchUpInside];
    more_btn.tag = section;
    [view addSubview:more_btn];
    return view;
}

- (void)jumpMore:(UIButton *)sender{
    YWClassViewController *classVC = [[YWClassViewController alloc]init];
    classVC.categories = _dataArray;
    classVC.leftTableCurRow = sender.tag;
    [self.navigationController pushViewController:classVC animated:YES];
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_dataArray.count == 0) {
        [self request];
    }
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
