//
//  YWshoppingController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWshoppingController.h"
#import "YWSearchBar.h"
#import "SDCycleScrollView.h"
#import "YWmainItemButton.h"
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
#import <UMSocial.h>
#import "YWViewController.h"
#import "YWLoginViewController.h"
#import "YWnaviViewController.h"
#import "YWfunctionButton.h"
#import "YWGuideViewController.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "SFTrainsitionAnimate.h"

@interface YWshoppingController ()<SDCycleScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,YWgoodsCellDelegate,UMSocialUIDelegate,UINavigationControllerDelegate>{
    UISearchBar *searchBar;
    UITableView *_tableView;
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
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 35)];
    searchBar.placeholder = @"大家都在搜";
    searchBar.returnKeyType = UIReturnKeyGo;
    searchBar.delegate = self;
    searchBar.layer.cornerRadius = 10;
    searchBar.layer.masksToBounds = YES;
    for (UIView *view in searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    //设置为导航栏的标题视图
    self.navigationItem.titleView = searchBar;
    
    UIButton *right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [right_btn setImage:[UIImage imageNamed:@"ic_mall_share_72(1)"] forState:UIControlStateNormal];
    [right_btn addTarget:self action:@selector(shared) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:right_btn];
    shareItem.imageInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    self.navigationItem.rightBarButtonItem = shareItem;
    
    UIButton *left_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIBarButtonItem *leftBrt = [[UIBarButtonItem alloc]initWithCustomView:left_btn];
    self.navigationItem.leftBarButtonItem = leftBrt;
    
    
    //创建分类
    [self creatItemize];
    
    //创建商品列表
    [self createTable];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gesture];
    
    
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

//创建分类
- (void)creatItemize{
    
    CGFloat itemWidth = (kScreenWidth-60-40)/3;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, 64, kScreenWidth-60, 51)];
    if (kScreenWidth == 320) {
        itemWidth = (kScreenWidth -40)/3;
        view.frame = CGRectMake(10, 64, kScreenWidth-10, 51);
    }
    [self.view addSubview:view];
    
    NSArray *titles = @[@"所有商品",@"商品分类",@"福利认领"];
    NSArray *images = @[@"ic_mall_fragment_all_goods.png",
                        @"ic_mall_fragment_goods_category",
                        @"ic_mall_fragment_syb"];
    
    for (int i = 0; i<3; i++) {
        YWfunctionButton *button = [[YWfunctionButton alloc]initWithFrame:CGRectMake(i*(itemWidth+20), 0, itemWidth, 51)];
        if (kScreenWidth == 320) {
            button.frame = CGRectMake(i*(itemWidth+10), 0, itemWidth, 51);
        }
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
}

//创建商品列表
- (void)createTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 115, kScreenWidth, KscreenHeight-115-49) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    NSArray *imageNames = @[@"show1",
                            @"show2",
                            @"show3"
                            ];

    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 140) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    cycleScrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _tableView.tableHeaderView = cycleScrollView;
    
    [self request];
    
}

- (void)request{
    [MBProgressHUD hideHUDForView:_tableView animated:YES];
    [MBProgressHUD showMessage:@"正在加载" toView:_tableView];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[Good MD5Digest],sKey]MD5Digest];
    parameters[@"gkd"] = [[@"0" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWGood parameters:parameters success:^(id responseObject) {
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
    cell.delegate = self;
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
    return 100;
    
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

- (void)coverDidClick:(NSIndexPath *)indexPath{
    if (![YWUserTool account]) {
        YWLoginViewController *loginVC = [[YWLoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }
        YWBuyViewController *buyVC = [[YWBuyViewController alloc]init];
        YWSorts *sorts = _dataArray[indexPath.section];
        buyVC.goods = sorts.Goods[indexPath.row];
        [self.navigationController pushViewController:buyVC animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ((inter++)%2 == 0) {
        SearchViewController *searchVC = [[SearchViewController alloc]init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    return YES;
}

//点击分类
- (void)clickBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            YWViewController *classVC = [[YWViewController alloc]init];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (YWSorts *sorts in _dataArray) {
                for (YWGoods *goods in sorts.Goods) {
                    [dataArray addObject:goods];
                }
            }
            classVC.dataArray = dataArray;
            [self.navigationController pushViewController:classVC animated:YES];
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
        {    YWGuideViewController *VC = [[YWGuideViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
                   }
            break;
        default:
            break;
    }
}

- (void)shared{
    YWUser *user = [YWUserTool account];
    if ([Utils isNull:user]) {
        YWLoginViewController *loginVC = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    NSMutableDictionary *parameters = [Utils paramter:Share ID:user.ID];
    [YWHttptool   GET:YWShare parameters:parameters success:^(id responseObject) {
        UIImage *image = [UIImage imageNamed:@"app"];
        NSString *str = responseObject[@"result"][@"saddr"];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = str;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = str;
        //调用快速分享接口
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"574cf23967e58e27de0001da"
                                          shareText:@"蚁窝宝希望您的参与。"                                                                     shareImage:image
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                           delegate:self];
    } failure:^(NSError *error) {
        
    }];

}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{

    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [MBProgressHUD showSuccess:@"分享成功"];
    }
    else{
        [MBProgressHUD showError:@"分享失败"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确定这个手势是否可以实现
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //判断这个账号和密码控件中是否都是第一响应者
    if (![searchBar isFirstResponder] ) {
        //都不是第一响应者的时候
        return NO;
    }
    return YES;
}

//隐藏键盘栏
- (void)hidenKeyboard
{
    [searchBar resignFirstResponder];
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
