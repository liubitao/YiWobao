//
//  YWShoplistViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWShoplistViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YWUserTool.h"
#import "YWHttptool.h"
#import "Utils.h"
#import "YWUser.h"
#import "YWheaderView.h"
#import "YWCell3.h"
#import "YWMoneyList.h"

@interface YWShoplistViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
    UILabel *label;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) YWheaderView *headerView;
@end

@implementation YWShoplistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户中心";
    self.view.backgroundColor = KviewColor;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64) style:UITableViewStyleGrouped];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, self.view.center.y-50, kScreenWidth, 40);
    label.text = @"您的商店还没有消费记录";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = YES;
    [self.view addSubview:label];
    //头视图
    [self header];
    [self.view addSubview:_tableView];
    //请求数据
    [self request];
   
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"YWCell3" bundle:nil] forCellReuseIdentifier:@"cell3"];
}

- (void)header{
    self.headerView = [[YWheaderView alloc]init];
    [[NSBundle mainBundle] loadNibNamed:@"YWheaderView" owner:_headerView options:nil];
    UIView *view = _headerView.view;
    view.height = 110;
    view.width = self.view.width;
    self.tableView.tableHeaderView = view;
}

- (void)request{
    [MBProgressHUD showMessage:@"正在获取数据" toView:self.tableView];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:my_shop ID:user.ID];
    [YWHttptool GET:YWmyshop parameters:paramter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            YWShop *shop = [YWShop yw_objectWithKeyValues:responseObject[@"result"]];
            [self.headerView setModel:shop];
            _dataArray = shop.monyelist;
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"errorMessage"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        [MBProgressHUD showError:@"请检查网络"];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_dataArray[indexPath.section]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMoneyList *model = _dataArray[indexPath.section];
    CGRect detailSize = [model.memo boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}context:nil];
    if (detailSize.size.height<=33) {
        detailSize.size.height = 33;
    }
    return detailSize.size.height-33+87;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
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
