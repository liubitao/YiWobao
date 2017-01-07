//
//  YWGuideViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/7/14.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWGuideViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YWHttptool.h"
#import <NSString+MD5.h>
#import "YWWelfare.h"
#import "YWTableViewCell.h"
#import "YWWelfareView.h"
#import "YWDetailsViewController.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "SDCycleScrollView.h"

@interface YWGuideViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray* dataArray;
@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;


@end

@implementation YWGuideViewController

- (SDCycleScrollView*)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 185) shouldInfiniteLoop:YES imageNamesGroup:self.imageArray];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _cycleScrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"福利列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64-49) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"E4E4E4"];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.cycleScrollView;
    [_tableView registerNib:[UINib nibWithNibName:@"YWTableViewCell" bundle:nil] forCellReuseIdentifier:@"welfare"];
    [self request];
}

- (void)request{
    NSMutableDictionary *parameter1 = [NSMutableDictionary dictionary];
    parameter1[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[getPics MD5Digest],sKey]MD5Digest];
    parameter1[@"getkd"] = [[@"1" dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool Post:YWgetPics parameters:parameter1 success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            if (![Utils isNull:responseObject[@"result"]]) {
                self.imageArray = [NSMutableArray array];
                for (NSString *imageStr in responseObject[@"result"]){
                    
                    NSString *str = [NSString stringWithFormat:@"%@%@",YWpic,imageStr];
                    [self.imageArray addObject:str];
                }
                self.cycleScrollView.imageURLStringsGroup = self.imageArray;
            }else{
                self.cycleScrollView.localizationImageNamesGroup = @[@"show1",@"show2",@"show3"];
            }
            return ;
        }
    } failure:^(NSError *error) {
    }];

    
    [MBProgressHUD showMessage:@"正在加载..."];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[zcproj MD5Digest],sKey]MD5Digest];
    parameter[@"bhim"] = [[user.pid dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool Post:YWzcproj parameters:parameter success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        [MBProgressHUD hideHUD];
        if (!isError) {
            _dataArray = [YWWelfare yw_objectWithKeyValuesArray:responseObject[@"result"]];
            [self.tableView reloadData];
            return ;
            }
         [MBProgressHUD showSuccess:responseObject[@"errorMessage"]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络..."];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"welfare" forIndexPath:indexPath];

    [cell setModel:_dataArray[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 55;
    }
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    view.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 35)];
        view1.backgroundColor = [UIColor whiteColor];
        [view addSubview:view1];
        
        UIView *leftImage = [[UIView alloc]initWithFrame:CGRectMake(7, 10, 3, 15)];
        leftImage.backgroundColor = [UIColor redColor];
        [view1 addSubview:leftImage];
        
        UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        sectionLabel.origin = CGPointMake(leftImage.right+5, 10);
        sectionLabel.size = CGSizeMake(kScreenWidth - sectionLabel.left, 15);
        sectionLabel.font = [UIFont systemFontOfSize:14];
        sectionLabel.text = @"最新福利";
        [view1 addSubview:sectionLabel];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kScreenWidth-55)/4+245-95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWDetailsViewController *detailsVC = [[YWDetailsViewController alloc]init];
    NSMutableDictionary *parameter1 = [NSMutableDictionary dictionary];
    YWWelfare *welfare = self.dataArray[indexPath.section];
    parameter1[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[detail MD5Digest],sKey]MD5Digest];
     parameter1[@"gid"] = [[welfare.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    parameter1[@"bhim"] = [[[YWUserTool account].ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [MBProgressHUD showMessage:@"加载中..."];
    [YWHttptool Post:YWdetail parameters:parameter1 success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            [MBProgressHUD hideHUD];
            YWWelfare *model = [YWWelfare yw_objectWithKeyValues:responseObject[@"result"]];
            detailsVC.welfare = model;
              [self pushController:detailsVC];
        }
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
