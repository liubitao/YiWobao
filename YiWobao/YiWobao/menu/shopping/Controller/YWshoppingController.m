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



@interface YWshoppingController ()<SDCycleScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YWgoodsCellDelegate,UMSocialUIDelegate>{
    YWSearchBar *searchBar;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation YWshoppingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = KviewColor;
    searchBar = [[YWSearchBar alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 35)];
    searchBar.placeholder = @"大家都在搜";
    searchBar.returnKeyType = UIReturnKeyGo;
    searchBar.delegate = self;
    //设置为导航栏的标题视图
    self.navigationItem.titleView = searchBar;
    
    //创建滚动图片
    [self creatRoll];
    
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

//创建滚动图片
- (void)creatRoll{
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, kScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    cycleScrollView3.currentPageDotImage = nil;
    cycleScrollView3.pageDotImage = nil;
    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
    [self.view addSubview:cycleScrollView3];
}
//创建分类
- (void)creatItemize{
    CGFloat itemWidth = kScreenWidth/4;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 240, kScreenWidth, itemWidth)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSArray *titles = @[@"所有商品",@"商品分类",@"转发分享",@"创业指导"];
    NSArray *images = @[@"ic_all_goods_72",
                        @"ic_goods_category_72",
                        @"ic_mall_share_72",
                        @"ic_syb_72"];
    
    for (int i = 0; i<4; i++) {
        YWmainItemButton *button = [[YWmainItemButton alloc]initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, itemWidth)];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
}

//创建商品列表
- (void)createTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenWidth/4+240, kScreenWidth, KscreenHeight-kScreenWidth/4-240-50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self request];
    
}

- (void)request{
    [MBProgressHUD showMessage:@"正在加载" toView:_tableView];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[Good MD5Digest],sKey]MD5Digest];
    parameters[@"gkd"] = [[@"0" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWGood parameters:parameters success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        [MBProgressHUD hideHUDForView:_tableView];
        if (!isError) {
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
    YWSorts *sorts = _dataArray[indexPath.section];
    [cell setCellModel:sorts.Goods[indexPath.row]];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    YWSorts *sorts = _dataArray[section];
    title.text = sorts.title;
    title.textColor = [UIColor greenColor];
    title.font = [UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
    YWSorts *sorts = _dataArray[indexPath.section];
    goodsVC.Goods = sorts.Goods[indexPath.row];
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (void)coverDidClick:(NSIndexPath *)indexPath{
    YWBuyViewController *buyVC = [[YWBuyViewController alloc]init];
    YWSorts *sorts = _dataArray[indexPath.section];
    buyVC.goods = sorts.Goods[indexPath.row];
    [self.navigationController pushViewController:buyVC animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return YES;
}

//点击分类
- (void)clickBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            YWViewController *classVC = [[YWViewController alloc]init];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (YWSorts *sorts in _dataArray) {
                for (int i = 0 ;i< sorts.Goods.count  ;i++) {
                    [dataArray addObject:sorts.Goods[i]];
                }
            }
            classVC.dataArray = dataArray;
            [self.navigationController pushViewController:classVC animated:YES];
        }
            break;
        case 1:{
            YWClassViewController *classVC = [[YWClassViewController alloc]init];
            classVC.categories = _dataArray;
            [self.navigationController pushViewController:classVC animated:YES];
        }
            break;
        case 2:
        {
            YWUser *user = [YWUserTool account];
            if ([Utils isNull:user]) {
                YWLoginViewController *loginVC = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            NSMutableDictionary *parameters = [Utils paramter:Share ID:user.ID];
            [YWHttptool   GET:YWShare parameters:parameters success:^(id responseObject) {
                UIImage *image = [UIImage imageNamed:@"weixin_icon_xxh"];
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
            break;
        case 3:
        break;
        default:
            break;
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
