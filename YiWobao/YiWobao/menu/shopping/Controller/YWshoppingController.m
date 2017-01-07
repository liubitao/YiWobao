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
#import "MPQRCodeViewController.h"
#import "YWmainItemButton.h"
#import "YWfunctionButton.h"
#import "YWFederalViewController.h"
#import "YWShopHeader.h"
#import "YWFreeGoodsViewController.h"
#import "YWWelfareTarBarController.h"


@interface YWshoppingController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
    UISearchBar *searchBar;
    
    int inter;
    YWShopHeader *header;
}

@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) SFTrainsitionAnimate    *animate;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *imageArray;


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
    MPQRCodeViewController *scanVC = [[MPQRCodeViewController alloc]init];
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
    header = [[YWShopHeader alloc]initWithFrame:({
        CGRect rect = {0,0,kScreenWidth,300};
            rect;
    })images:images];
    __weak typeof(self) weakSelf = self;
    header.menuBlcok = ^(NSInteger i){
        switch (i) {
            case 0:{//免费
                YWFreeGoodsViewController *freeVC = [[YWFreeGoodsViewController alloc]init];
                freeVC.dataArray = [NSMutableArray array];
                for (YWSorts *sorts in weakSelf.dataArray) {
                    if (sorts.ID.integerValue == 12 || sorts.ID.integerValue == 20) {
                        [freeVC.dataArray addObjectsFromArray:sorts.Goods];
                    }
                }
                freeVC.title = @"免费商品";
                [weakSelf.navigationController pushViewController:freeVC animated:YES];
            }
                break;
            case 1:{
                YWClassViewController *classVC = [[YWClassViewController alloc]init];
                classVC.dataArray = [NSMutableArray array];
                for (YWSorts *sorts in weakSelf.dataArray) {
                    if (sorts.ID.integerValue != 12 && sorts.ID.integerValue != 20) {
                        [classVC.dataArray addObject:sorts];
                    }
                }
                [weakSelf.navigationController pushViewController:classVC animated:YES];
            }
                break;
            case 2:
            {
                YWFederalViewController *FederalVC = [[YWFederalViewController alloc]init];
                [weakSelf.navigationController pushViewController:FederalVC animated:YES];
            }
                break;
            case 3:
            {
                if (![YWUserTool account]) {
                    YWLoginViewController *loginVC = [[YWLoginViewController alloc]init];
                    [weakSelf presentViewController:loginVC animated:YES completion:nil];
                    return;
                }
                YWWelfareTarBarController *VC = [[YWWelfareTarBarController alloc]init];
//                VC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
                [weakSelf presentViewController:VC animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    };
    header.middleBlcok = ^(NSInteger ID){//点击html页面中的商品
         weakSelf.sf_targetView = nil;
        [weakSelf requestID:[NSString stringWithFormat:@"%zi",ID]];
    };
    __weak typeof(header) weakHeader = header;
    header.heightBlcok = ^(CGFloat height){//头高
        weakHeader.height = height +310+10;
        weakSelf.tableView.tableHeaderView = weakHeader;
    };
    
    header.middleClick = ^(){//免费商品更多
        YWFreeGoodsViewController *freeVC = [[YWFreeGoodsViewController alloc]init];
        freeVC.dataArray = [NSMutableArray array];
        for (YWSorts *sorts in weakSelf.dataArray) {
            if (sorts.ID.integerValue == 12 || sorts.ID.integerValue == 20) {
                [freeVC.dataArray addObjectsFromArray:sorts.Goods];
            }
        }
        freeVC.title = @"免费商品";
        [weakSelf.navigationController pushViewController:freeVC animated:YES];
    };
    
    _tableView.tableHeaderView = header;

    [self request];
    
}

- (void)requestID:(NSString *)ID{
    
    [MBProgressHUD hideHUDForView:_tableView animated:YES];
    [MBProgressHUD showMessage:@"正在加载" toView:_tableView];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[goodsDetails MD5Digest],sKey]MD5Digest];
    parameters[@"gid"] = [[ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWgoodsDetail parameters:parameters success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
        [MBProgressHUD hideHUDForView:_tableView];
        YWGoods *goods = [YWGoods yw_objectWithKeyValues:responseObject[@"result"]];
        YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
       
        goodsVC.Goods = goods;
        [self.navigationController pushViewController:goodsVC animated:YES];
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDForView:_tableView];
        [MBProgressHUD showError:@"请检查网络" toView:_tableView];
    }];

}

- (void)request{
    
    NSMutableDictionary *parameter1 = [NSMutableDictionary dictionary];
    parameter1[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[getPics MD5Digest],sKey]MD5Digest];
    parameter1[@"getkd"] = [[@"2" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool Post:YWgetPics parameters:parameter1 success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            if (![Utils isNull:responseObject[@"result"]]) {
                self.imageArray = [NSMutableArray array];
                for (NSString *imageStr in responseObject[@"result"]) {
                    NSString *str = [NSString stringWithFormat:@"%@%@",YWpic,imageStr];
                    [self.imageArray addObject:str];
                }
                [header setImages:self.imageArray];
            }
            return ;
        }
    } failure:^(NSError *error) {
    }];
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
            NSMutableArray *array = [YWSorts yw_objectWithKeyValuesArray:responseObject[@"result"]];
            for (YWSorts *sorts in array) {
                if (![Utils isNull:sorts.Goods]) {
                    [_dataArray addObject:sorts];
                }
            }
            for (int i = 0;i<_dataArray.count;i++) {
                YWSorts *sort = _dataArray[i];
                if (sort.ID.integerValue == 20) {
                    [_dataArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
                }
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
    [more_btn setImage:[UIImage imageNamed:@"ic_mall_fragment_more"] forState:UIControlStateNormal];
    [more_btn addTarget:self action:@selector(jumpMore:) forControlEvents:UIControlEventTouchUpInside];
    more_btn.tag = section;
    [view addSubview:more_btn];
    return view;
}

- (void)jumpMore:(UIButton *)sender{
    YWFreeGoodsViewController *freeVC = [[YWFreeGoodsViewController alloc]init];
    freeVC.dataArray = [NSMutableArray array];
    YWSorts *sorts = _dataArray[sender.tag];
    [freeVC.dataArray addObjectsFromArray:sorts.Goods];
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
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


@end
