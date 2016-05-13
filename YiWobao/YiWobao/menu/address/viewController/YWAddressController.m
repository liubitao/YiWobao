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

@interface YWAddressController ()<UITableViewDelegate,UITableViewDataSource,YWAderssCellDelegate>
{
    NSMutableArray *_addressFrames;
    YWAderssCell *_lastCell;
    
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation YWAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KviewColor;
    self.title = @"地址管理";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, KscreenHeight) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //请求网络上的地址数据
    [self requestAddress];
    
    //添加退出按钮
    UIButton *exitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KscreenHeight-50, kScreenWidth, 50)];
    exitButton.backgroundColor = [UIColor redColor];
    [exitButton setTitle:@"添加地址" forState:UIControlStateNormal];
    [exitButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [exitButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
}


- (void)requestAddress{
    YWAddressModel *model = [[YWAddressModel alloc]init];
    model.name = @"刘毕涛";
    model.address = @"湖北省仙桃市西流河镇周壕村一组湖北省仙桃市西流河镇周壕村一组湖北省仙桃市西流河镇周壕村一组湖北省仙桃市西流河镇周壕村一组湖北省仙桃市西流河镇周壕村一组湖北省仙桃市西流河镇周壕村一组";
    model.phone = @"15068891471";
    model.defualt = NO;
    NSArray *array = @[model,model,model,model];
    _addressFrames = [NSMutableArray array];
    for (YWAddressModel *adderss in array){
        YWAddressFrame *addressFrame = [[YWAddressFrame alloc]init];
        addressFrame.model = adderss;
        [_addressFrames addObject:addressFrame];
    }
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
    
    if (addressFrame.model.defualt) {
        _lastCell = cell;
    }
    //给cell传递模型
    [cell configModel:addressFrame];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
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
            [_lastCell.defaultButoon setImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
            YWAderssCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
            [cell.defaultButoon setImage:[UIImage imageNamed:@"tabbar_profile"] forState:UIControlStateNormal];
            _lastCell = cell;
            
        }
            break;
        case 2:
        {   YWAddressFrame *frame = _addressFrames[indexpath.section];
            YWAddressModel *model = frame.model;
            YWAddressEditController *editVC = [[YWAddressEditController alloc]init];
            editVC.name = model.name;
            editVC.phone = model.phone;
            editVC.address = model.address;
            [self.navigationController pushViewController:editVC animated:YES];
        }
            break;
        case 3:
        { //设置提醒框
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                YWLog(@"删除");
                
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


- (void)add:(UIButton *)sender{
       YWAddressEditController *editVC = [[YWAddressEditController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}
@end
