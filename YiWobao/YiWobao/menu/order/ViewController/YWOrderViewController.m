//
//  YWOrderViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWOrderViewController.h"
#import "YWHttptool.h"
#import "YWOrderCell.h"
#import "YWOrderModel.h"
#import "Utils.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "MBProgressHUD+MJ.h"
#import <NSString+MD5.h>
#import <UMSocial.h>
#import "YWGoods.h"
#import "YWPayViewController.h"


#define kRequestTime 3.0f
#define kDelay 1.0f

@interface YWOrderViewController ()<YWOrderCellDelegate,UMSocialUIDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation YWOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"E5E6E6"];;
    _dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求数据
    [self request];
}

- (void)request{
    [MBProgressHUD showMessage:@"正在获取数据"];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:Trlist ID:user.ID];
    paramter[@"okd"] = [[_type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWOrderList parameters:paramter success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            [_dataArray removeAllObjects];
            if (![Utils isNull:responseObject[@"result"]]){
            for (NSDictionary *dict in responseObject[@"result"]) {
               YWOrderModel *orderModel = [YWOrderModel yw_objectWithKeyValues:dict];
                [_dataArray addObject:orderModel];
            }
        }
        }
        [self.tableView reloadData];
       
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWOrderModel *orederModel = _dataArray[indexPath.section];
    YWOrderCell  *cell;
    if ([_type isEqualToString:@"3"]) {
        if ([orederModel.paystatus isEqualToString:@"0"] && [orederModel.paykind isEqualToString:@"2"]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell3"];
            if (!cell) {
                cell = [[YWOrderCell alloc]                         initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell3"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.type = @"2";
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell2"];
            if (!cell) {
                cell = [[YWOrderCell alloc]                         initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.type = @"2";
            }
        }
    }else{
    
    if ([orederModel.paystatus isEqualToString:@"0"] && [orederModel.paykind isEqualToString:@"2"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell1"];
        if (!cell) {
            cell = [[YWOrderCell alloc]                         initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             cell.type = @"1";
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell2"];
        if (!cell) {
            cell = [[YWOrderCell alloc]                         initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = @"1";
        }
    }}
    [cell setModel:_dataArray[indexPath.section]];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWOrderModel *orederModel = _dataArray[indexPath.section];
    if ([orederModel.paystatus isEqualToString:@"0"] && [orederModel.paykind isEqualToString:@"2"]) {
        return 164;
    }
    return  125;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)changeState:(NSIndexPath *)indexPath tag:(NSInteger)tag type:(NSString *)type{
    if (tag == 1) {
        //设置提醒框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[type isEqualToString:@"1"]?  @"确认取消该订单":@"确认拒绝该代付" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *str = [type isEqualToString:@"1"]?  @"正在取消订单":@"正在拒绝代付";
            NSString *str2 = [type isEqualToString:@"1"]?  @"已取消":@"已拒绝";
            [MBProgressHUD showMessage:str];
            YWOrderModel *orederModel = _dataArray[indexPath.section];
            YWUser *user = [YWUserTool account];
            NSMutableDictionary *parameters = [Utils paramter:Del_order ID:user.ID];
            parameters[@"doid"] = [[orederModel.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
            parameters[@"dkd"] = [[type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
            [YWHttptool Post:YWDelOrder parameters:parameters success:^(id responseObject) {
                NSInteger isError = [responseObject[@"isError"] integerValue];
                [MBProgressHUD hideHUD];
                if (!isError) {
                    [self request];
                    [MBProgressHUD showSuccess:str2];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请检查网络"];
            }];
        }];
        [action1 setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:action1];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        if ([type isEqualToString:@"2"]) {
            YWOrderModel *orederModel = _dataArray[indexPath.section];
            YWGoods *goods = orederModel.goods;
            
            NSMutableDictionary *buyarr = [NSMutableDictionary dictionary];
            buyarr[@"oid"] = orederModel.ID;
            
            YWPayViewController *payVC = [[YWPayViewController alloc]init];
            payVC.buyArr = buyarr;
            payVC.total = orederModel.pmoney;
            if ([goods.ybkind isEqualToString:@"0"]) {
                payVC.yb_can = YES;
            }else {
                payVC.yb_can = NO;
            }
            [self presentViewController:payVC animated:YES completion:nil];

        }
        else{
            YWOrderModel *orederModel = _dataArray[indexPath.section];
            YWUser *user = [YWUserTool account];
            NSMutableDictionary *parameters = [Utils paramter:SeeEwm ID:user.ID];
            parameters[@"doid"] = [[orederModel.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
            //商品图片
            YWGoods *good = orederModel.goods;
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",YWpic,good.pic];
            
           //内容
            NSString *str = [NSString stringWithFormat:@"长按二维码识别,帮我代付%@,数量：%@，总价：%@米",good.title,orederModel.num,orederModel.pmoney];
            
            [YWHttptool GET:YWSeeEwm parameters:parameters success:^(id responseObject) {
                NSString *picStr = [NSString stringWithFormat:@"%@%@",YWShareCode,responseObject[@"result"]];
               [UMSocialData defaultData].extConfig.wechatSessionData.url = picStr;
                
                UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                    imageUrl];
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:str image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                    if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                        [MBProgressHUD showSuccess:@"分享成功"];
                    }
                }];
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"分享失败"];
            }];
            
        }
    }
        
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无相关记录...";
    return [[NSAttributedString alloc] initWithString:text attributes:@{
                                                                        NSFontAttributeName:[UIFont systemFontOfSize:20]
                                                                        }];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;{
    return -64;
}

@end
