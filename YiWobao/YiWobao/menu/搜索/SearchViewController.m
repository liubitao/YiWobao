//
//  SearchViewController.m
//  NewPower
//
//  Created by 刘毕涛 on 16/2/16.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "SearchViewController.h"
#import "YWHttptool.h"
#import "YWgoodsCell.h"
#import "YWGoods.h"
#import "YWGoodsViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YWBuyViewController.h"
#import "YWSorts.h"
#import "YWLoginViewController.h"
#import "YWUserTool.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "SFTrainsitionAnimate.h"

@interface SearchViewController ()<UIGestureRecognizerDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    UISearchBar *_searchView;
    NSMutableArray *_dataArray;
    BOOL _wasKeyboardManagerEnabled;
}
@property (strong, nonatomic) SFTrainsitionAnimate    *animate;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品搜索";
    self.view.backgroundColor = KviewColor;
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.alpha = 0.8;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
 
    _searchView = [[UISearchBar alloc]init];
    _searchView.barStyle = UIBarStyleDefault;
    _searchView.backgroundColor = [UIColor clearColor];
    _searchView.placeholder = @"请输入商品";

    for (UIView *view in _searchView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    _searchView.tintColor=[UIColor blueColor];
    _searchView.delegate = self;
    self.navigationItem.titleView = _searchView;
    [_searchView becomeFirstResponder];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    // 注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"YWgoodsCell" bundle:nil] forCellReuseIdentifier:@"goodsCell"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
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

//隐藏键盘栏
- (void)hidenKeyboard
{
    [_searchView resignFirstResponder];
}

//确定这个手势是否可以实现
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //判断这个账号和密码控件中是否都是第一响应者
    if (![_searchView isFirstResponder]) {
        
        //都不是第一响应者的时候
        return NO;
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self requestWith:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
     [self requestWith:searchBar.text];
}

-(void)requestWith:(NSString *)poi{
    [MBProgressHUD showMessage:@"正在加载" toView:_tableView];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[Search MD5Digest],sKey]MD5Digest];
    parameters[@"gsearch"] = [[poi dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWSearch parameters:parameters success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        [MBProgressHUD hideHUDForView:_tableView];
        if (!isError) {
            _dataArray = [YWGoods yw_objectWithKeyValuesArray:responseObject[@"result"]];
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_tableView];
        [MBProgressHUD showError:@"请检查网络"];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWgoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
    [cell setCellModel:_dataArray[indexPath.row]];
    cell.indexPath = indexPath;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWgoodsCell *cell = (YWgoodsCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.sf_targetView = cell.picView;
    
    YWGoodsViewController *goodsVC = [[YWGoodsViewController alloc]init];
    goodsVC.Goods = _dataArray[indexPath.row];
    [self.navigationController pushViewController:goodsVC animated:YES]; 
}





-(void)viewWillDisappear:(BOOL)animated
{
    if ([_searchView isFirstResponder]) {
        [_searchView resignFirstResponder];
    }
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
