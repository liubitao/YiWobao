//
//  YWFederalViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWFederalViewController.h"
#import "YWBaseViewController.h"
#import "YWFederal.h"
#import "HomeMenuCell.h"
#import "YWShopClassViewController.h"
#import "YWFederalShop.h"
#import "YwFederalCell.h"
#import "YWShopDetailsController.h"

@interface YWFederalViewController ()<UITableViewDataSource,UITableViewDelegate,YWhomeMenuDelegate>{
    NSMutableArray *_menuArray;
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation YWFederalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YwFederalCell" bundle:nil] forCellReuseIdentifier:@"shopcell"];
    self.title = @"联盟商家";
//    [self initNavi];
    
    [self request];
}

- (void)initNavi{
    [super initNavi];
}

- (void)request{
    [MBProgressHUD hideHUDForView:_tableView animated:YES];
    [MBProgressHUD showMessage:@"正在加载" toView:_tableView];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[shops_list MD5Digest],sKey]MD5Digest];
    parameters[@"skd"] = [[@"0" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWshopList parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger isError = [responseObject[@"isError"] integerValue];
        [MBProgressHUD hideHUDForView:_tableView];
        if (!isError){
            _menuArray = [YWFederal yw_objectWithKeyValuesArray:responseObject[@"result"]];
            NSMutableArray *shops = [NSMutableArray array];
            for (YWFederal *federal in _menuArray) {
                [shops addObject:federal.title];
                NSArray *array = federal.shops;
                if (![Utils isNull:array]) {
                    [_dataArray addObjectsFromArray:array];
                }
            }
            NSUserDefaults *defait = [NSUserDefaults standardUserDefaults];
            [defait setObject:shops forKey:@"shops"];
            [defait synchronize];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_tableView];
        [MBProgressHUD showError:@"请检查网络" toView:_tableView];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+_dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }else if(indexPath.section == 1){
            return 168;
    }else{
        return 125;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = RGB(239, 239, 244);
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    footerView.backgroundColor = RGB(239, 239, 244);
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIndentifier = @"menucell";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil || ![Utils isNull:_menuArray]) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellIndentifier = @"piccell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,160)];
            imageView.image = [UIImage imageNamed:@"food"];
            [cell.contentView addSubview:imageView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        static NSString *cellIndentifier = @"shopcell";
        YwFederalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
        YWFederalShop *shop = _dataArray[indexPath.section - 2];
        [cell setCellModel:shop];
        return cell;

    }
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 || indexPath.section == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWShopDetailsController *shopVC = [[YWShopDetailsController alloc]init];
    shopVC.shop = _dataArray[indexPath.section -2];
    [self.navigationController pushViewController:shopVC animated:YES];
}

- (void)didSelected:(NSInteger)number{
    YWShopClassViewController *shopVC = [[YWShopClassViewController alloc]init];
    YWFederal *fedral = _menuArray[number];
    shopVC.federal = _menuArray[number];
    shopVC.title = fedral.title;
    [self.navigationController pushViewController:shopVC animated:YES];
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
