//
//  YWAddressController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWAddressController.h"
#import "YWAddressModel.h"
#import "YWAderssCell.h"
#import "YWAddressFrame.h"
#import "YWAddressEditController.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "Utils.h"
#import "YWHttptool.h"


@interface YWAddressController ()<UITableViewDelegate,UITableViewDataSource,YWAderssCellDelegate>
{
    NSMutableArray *_addressFrames;
    YWAderssCell *_lastCell;
    
}
@property (nonatomic,strong) UILabel *label;

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation YWAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KviewColor;
    self.title = @"地址管理";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, KscreenHeight-50-64) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //请求网络上的地址数据
    [self requestAddress];
    
    //添加添加按钮
    UIButton *exitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KscreenHeight-50, kScreenWidth, 50)];
    exitButton.backgroundColor = KthemeColor;
    [exitButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    [exitButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [exitButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    
    _label = [[UILabel alloc]init];
    _label.frame = CGRectMake(0, self.view.center.y-50, kScreenWidth, 40);
    _label.text = @"您还没有保存收货地址";
    _label.font = [UIFont systemFontOfSize:20];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.hidden = YES;
    [self.view addSubview:_label];
    
}


- (void)requestAddress{
    _label.hidden = YES;
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *parameters = [Utils paramter:Addres ID:user.ID];
    [YWHttptool GET:YWAddrList parameters:parameters success:^(id responseObject) {
        if ([Utils isNull:responseObject[@"result"]]) {
            _label.hidden = NO;
        }else{
              NSMutableArray *array = [YWAddressModel yw_objectWithKeyValuesArray:responseObject[@"result"]];
            _addressFrames = [NSMutableArray array];
            for (YWAddressModel *adderss in array){
                YWAddressFrame *addressFrame = [[YWAddressFrame alloc]init];
                addressFrame.model = adderss;
                [_addressFrames addObject:addressFrame];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _addressFrames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (YWAderssCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     YWAderssCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" ];
    if (!cell) {
        cell = [[YWAderssCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
        
    }
    //获取address模型
    YWAddressFrame *addressFrame = _addressFrames[indexPath.section];
    cell.indexpath = indexPath;
    cell.delegate = self;
    if ([addressFrame.model.isselect isEqualToString:@"1"]) {
        _lastCell = cell;
    }
    //给cell传递模型
    [cell configModel:addressFrame];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWAddressFrame *addressFrame = _addressFrames[indexPath.section];
    return addressFrame.cellHeight;
}

- (void)clickCell:(NSIndexPath *)indexpath tag:(NSInteger)tag{
    //点击地址管理
    switch (tag) {
        case 1:
        {
            [_lastCell.defaultButoon setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
            [_lastCell.defaultButoon setTitle:@"设为默认" forState:UIControlStateNormal];
            [_lastCell.defaultButoon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            YWAderssCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
            [cell.defaultButoon setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
            [cell.defaultButoon setTitle:@"默认地址" forState:UIControlStateNormal];
            [cell.defaultButoon setTitleColor:KthemeColor forState:UIControlStateNormal];
            _lastCell = cell;
            [self setOrdelete:[NSString stringWithFormat:@"%ld",tag] indexpath:indexpath];
        }
            break;
        case 2:
        {   YWAddressFrame *frame = _addressFrames[indexpath.section];
            YWAddressEditController *editVC = [[YWAddressEditController alloc]init];
            editVC.addressModel = frame.model;
            [self.navigationController pushViewController:editVC animated:YES];
        }
            break;
        case 3:
        { //设置提醒框
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self setOrdelete:[NSString stringWithFormat:@"%ld",tag-1] indexpath:indexpath];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            [alertController addAction:action1];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

//删除，设置默认地址
- (void)setOrdelete:(NSString *)number indexpath:(NSIndexPath*)indexpath{
    YWUser *user = [YWUserTool account];
    YWAddressFrame *frame = _addressFrames[indexpath.section];
    YWAddressModel *model = frame.model;
    NSMutableDictionary *parametrs = [Utils paramter:SetAddr ID:user.ID];
    parametrs[@"aim"] = [[model.ID dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    parametrs[@"akd"] = [[number dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool Post:YWSetAddr parameters:parametrs success:^(id responseObject) {
        if ([number isEqualToString:@"2"]) {
            [_addressFrames removeAllObjects];
            if (![Utils isNull:responseObject[@"result"]]){
                _label.hidden = YES;
                NSMutableArray *array = [YWAddressModel yw_objectWithKeyValuesArray:responseObject[@"result"]];
                for (YWAddressModel *adderss in array){
                    YWAddressFrame *addressFrame = [[YWAddressFrame alloc]init];
                    addressFrame.model = adderss;
                    [_addressFrames addObject:addressFrame];
                }
            }else{
                _label.hidden = NO;
            }
             [_tableView reloadData];
            }
    } failure:^(NSError *error) {
    }];
}

- (void)add:(UIButton *)sender{
    YWAddressEditController *editVC = [[YWAddressEditController alloc]init];
    editVC.type = @"1";
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAddress];
}
@end
