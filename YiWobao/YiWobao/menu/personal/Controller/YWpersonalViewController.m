//
//  YWpersonalViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWpersonalViewController.h"
#import "YlListButton.h"
#import "YWPopView.h"
#import "YWCover.h"
#import "YWLeftViewController.h"
#import "YWmainView.h"
#import "YWFunctionModel.h"
#import "YWSettingTableController.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"
#import "YWHttptool.h"
#import "YWOrderViewController.h"
#import "YWListViewController.h"
#import "YWInViewController.h"
#import "YWtransferViewController.h"
#import "YWTjrTableController.h"
#import <UMSocial.h>
#import "MBProgressHUD+MJ.h"
#import "YWNextPerson.h"
#import "YWNextViewController.h"
#import <AFNetworking.h>
#import "YWshoppingController.h"
#import "YWfunctionButton.h"
#import "YWInformationController.h"
#import "YWPopuepController.h"


@interface YWpersonalViewController ()<YWCoverDelegate,YWLeftDelegate,YWmainViewDelegate,UMSocialUIDelegate,UIGestureRecognizerDelegate>{
    UILabel *ant_number;
    UILabel *name_label;
    YWCover *cover;
    UIView *personView;
    UIView *personView1;
    UIView *personView2;
}

@property (nonatomic,strong) NSArray *functionData;

@property (nonatomic,strong) YWLeftViewController *leftView;


@property (strong, nonatomic) YWmainView *menu;





@end

@implementation YWpersonalViewController


-(YWLeftViewController*)leftView{
    if (_leftView == nil) {
        _leftView = [[YWLeftViewController alloc]init];
        _leftView.delegate = self;
        _leftView.dataArray = [NSMutableArray array];
    }
     YWUser *user = [YWUserTool account];
    if ([Utils isNull:user.zc_g1]) {
        [_leftView.dataArray addObject:@"0"];
    }else{
        [_leftView.dataArray addObject:user.zc_g1];
    }
    if ([Utils isNull:user.zc_g2]) {
        [_leftView.dataArray addObject:@"0"];
    }else{
        [_leftView.dataArray addObject:user.zc_g2];
    }
    if ([Utils isNull:user.zc_g3]) {
        [_leftView.dataArray addObject:@"0"];
    }else{
        [_leftView.dataArray addObject:user.zc_g3];
    }
    return _leftView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    self.view.backgroundColor = KviewColor;
    

    //创建中间的视图
    [self createUser];
    //创建钱币UI
    [self creatAntUI];
    //创建功能按钮
    [self creatFunctionButton];
    //创建提现和充值
    [self recharge];
}

//创建中间的视图
- (void)createUser{
    //判断是否有存储在本地的数据
    YWUser *user = [YWUserTool account];
    
    UIView *headView = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0  Y:0 width:375 height:212]];
    headView.backgroundColor = KthemeColor;
    [self.view addSubview:headView];
    
    personView = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0  Y:80 width:375 height:212-80]];
    personView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipPerson)];
    tap1.numberOfTapsRequired = 1;
    [headView addSubview:personView];
    [personView addGestureRecognizer:tap1];
    
    personView1 = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0  Y:20 width:80 height:60]];
    personView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftClick:)];
    tap2.numberOfTapsRequired = 1;
    [headView addSubview:personView1];
    [personView1 addGestureRecognizer:tap2];
    
    personView2= [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:375-80  Y:20 width:80 height:60]];
    personView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSetting)];
    tap3.numberOfTapsRequired = 1;
    [headView addSubview:personView2];
    [personView2 addGestureRecognizer:tap3];
    
    //左边的按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = [FrameAutoScaleLFL CGLFLMakeX:24 Y:57 width:70 height:15];
    [self.view addSubview:leftbutton];
    [leftbutton setImage:[UIImage imageNamed:@"ic_me_fragment_referrer"] forState:UIControlStateNormal];
    leftbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftbutton setTitle:@"推荐人" forState:UIControlStateNormal];
    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftbutton.titleLabel.font = [UIFont systemFontOfSize:leftbutton.height];
    //高亮的时候不用变化图片
    [leftbutton addTarget:self  action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //右边的按钮
    UIButton *rightButton = [[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:323 Y:57 width:30 height:15]];
    [rightButton setTitle:@"设置" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:rightButton.height];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    rightButton.titleLabel.textColor = [UIColor whiteColor];
    [rightButton addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    //头像
    UIImageView *portrait = [[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:39      Y:94   width:96 height:96]];
    //设置圆角
    portrait.layer.cornerRadius = portrait.height/2;
    [portrait.layer setMasksToBounds:YES];
    [headView addSubview:portrait];
    
    //实业董事
    UILabel *work_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:150 Y:152 width:53 height:12]];
    work_label.font = [UIFont systemFontOfSize:work_label.height];
    work_label.textColor = [UIColor whiteColor];
    [headView addSubview:work_label];
    
    //昵称
    name_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:150 Y:122 width:140 height:18]];
    name_label.font = [UIFont systemFontOfSize:name_label.height];
    name_label.textAlignment = NSTextAlignmentLeft;
    name_label.textColor = [UIColor whiteColor];
    [headView addSubview:name_label];
    
    //编号
    UILabel *number_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:221    Y:152   width:75 height:12]];
    number_label.textAlignment = NSTextAlignmentRight;
    number_label.font = [UIFont systemFontOfSize:number_label.height];
    number_label.textColor = [UIColor whiteColor];
    [headView addSubview:number_label];
    
    //中间的线
    UIView *line_view = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:150 Y:145 width:145 height:1]];
    line_view.height = 1;
    line_view.backgroundColor = [UIColor whiteColor];
    [headView addSubview:line_view];
    
    UIView *line_view2 = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:213 Y:152 width:1 height:12]];
    line_view2.backgroundColor = [UIColor whiteColor];
    [headView addSubview:line_view2];
    
    UIButton *more_btn = [[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:333 Y:132 width:12 height:24]];
    [more_btn setBackgroundImage:[UIImage imageNamed:@"ic_me_fragment_go_to"] forState:UIControlStateNormal];
    [headView addSubview:more_btn];
    
    if (user) {
        [portrait sd_setImageWithURL:[NSURL URLWithString:user.userimg] placeholderImage:[UIImage imageNamed:@"default－portrait"]];
        if ([user.userkind isEqualToString:@"0"]) {
            work_label.text = @"游客";
        }else if ([user.userkind isEqualToString:@"1"]){
            work_label.text = @"事业董事";
        }else{
            work_label.text = @"创业领袖";
        }
        
        if ([Utils isNull:user.username]) {
            name_label.text = user.wxname;
        }else{
            name_label.text = user.username;
        }
        NSInteger number = [user.ID integerValue]+500000;
        number_label.text = [NSString stringWithFormat:@"编号:%ld",number];

    }
}
//创建钱币UI
- (void)creatAntUI{
    UIView *ant_view = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:212 width:375 height:50]];
    ant_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ant_view];
    
    //创建蚁币
    ant_number = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:45 Y:17 width:375-45 height:17]];
    //判断是否有存储在本地的数据
    YWUser *user = [YWUserTool account];
    NSString *str1 = [NSString stringWithFormat:@"蚁币  %@",user.chmoney];
    NSRange range1 = [str1 rangeOfString:@"蚁币  "];
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:str1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f],
                                                                                                            NSForegroundColorAttributeName:[UIColor redColor]}];
    [string1 addAttribute:NSForegroundColorAttributeName value:KtitlwColor range:range1];
    [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:range1];
    ant_number.attributedText = string1;
    [ant_view addSubview:ant_number];
    
    UIView *headView = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0  Y:269 width:375 height:71]];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    //七日收益
    UILabel *day_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:45 Y:17 width:80 height:15]];
    day_label.font = [UIFont systemFontOfSize:13];
    day_label.text = @"七日收益";
    day_label.textColor  = KtitlwColor;
    [headView addSubview:day_label];
    
    UIView *line = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:151  Y:14 width:1 height:48]];
    line.backgroundColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:0.5];
    [headView addSubview:line];
    
    //七日收益的数量
    UILabel *day_number = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:45 Y:38 width:100 height:22]];
    day_number.font = [UIFont systemFontOfSize:20];
    day_number.textColor = KthemeColor;
    [headView addSubview:day_number];
    
    //累计收益
    UILabel *all_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:190 Y:17 width:80 height:15]];
    all_label.font = [UIFont systemFontOfSize:13];
    all_label.text = @"累计收益";
    all_label.textColor = KtitlwColor;
    [headView addSubview:all_label];
    
    //累计收益的数量
    UILabel *all_number = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:191 Y:38 width:375-191 height:22]];
    all_number.font = [UIFont systemFontOfSize:20];
    all_number.textColor = KthemeColor;
    [headView addSubview:all_number];
    
    if ([Utils isNull:user.sr_0]) {
        all_number.text = @"+0";
    }else{
        all_number.text = [NSString stringWithFormat:@"+%@",user.sr_0];
    }
    if ([Utils isNull:user.sr_7]) {
        day_number.text = @"+0";
    }
    else{
        day_number.text = [NSString stringWithFormat:@"+%@",user.sr_7];
    }
}
//创建功能按钮
- (void)creatFunctionButton{
    YWmainView *mainView = [[YWmainView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:347 width:375 height:375/2+1]];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.bounces = NO;
    mainView.scrollEnabled = NO;
    mainView.contentSize = [FrameAutoScaleLFL CGSizeLFLMakeWidth:375 hight:375/4*3];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.mainDelegate = self;
    
    NSArray *array = @[@{@"订单" : @"ic_me_order_72"}, 
                      @{@"帮我代付" : @"ic_help_me_pay_72"},
                       @{@"我要代付" : @"ic_help_other_pay_72.png"},
                       @{@"转账" : @"ic_transfer_accounts_72"},
                       @{@"收益记录" : @"ic_gain_recording_72"},
                       @{@"提现记录" : @"ic_withdraw_recording_72"},
                       @{@"转账记录" : @"ic_transfer_accounts_recording_72"},
                       @{@"充值记录" : @"ic_recharge_recording_72"},
                       ];
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:8];
    for (NSDictionary *dictionary in array) {
        YWFunctionModel *model = [[YWFunctionModel alloc]init];
        model.title = dictionary.allKeys[0];
        model.imageString = dictionary.allValues[0];
        [dataArray addObject:model];
    }
    mainView.dataArray = dataArray ;
    [mainView config];
    [self.view addSubview:mainView];
    
}
//创建充值
- (void)recharge{
    UIView *ant_view = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:347+375/2+1 width:375 height:667-347-375/2-49]];
    ant_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ant_view];
    
    //创建充值
    UIButton *recarge_button = [[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:0 width:375/2 height:ant_view.height]];
    recarge_button.tag = 10;
    [recarge_button setTitle:@"充值" forState:UIControlStateNormal];
    [recarge_button setBackgroundImage:[UIImage imageWithColor:KviewColor] forState:UIControlStateHighlighted];
    [recarge_button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [recarge_button setTitleColor:KthemeColor forState:UIControlStateNormal];
    [ant_view addSubview:recarge_button];
    
    //创建提现
    UIButton *cashs_button = [[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:375/2-1 Y:0 width:375/2 height:ant_view.height]];
    cashs_button.tag = 20;
    [cashs_button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [cashs_button setBackgroundImage:[UIImage imageWithColor:KviewColor] forState:UIControlStateHighlighted];
    [cashs_button setTitle:@"提现" forState:UIControlStateNormal];
    [cashs_button setTitleColor:KthemeColor forState:UIControlStateNormal];
    [ant_view addSubview:cashs_button];
}

- (void)skipPerson{
    YWInformationController *VC = [[YWInformationController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}
//充值或提现
- (void)click:(UIButton *)sender{
    if (sender.tag == 10) {
        YWPopuepController *VC = [[YWPopuepController alloc]init];
        //弹出蒙版
        cover = [YWCover show];
        cover.delegate = self;
        [cover setDimBackground:YES];
        
        // 弹出pop菜单
        YWPopView *menu = [YWPopView showInRect:CGRectZero];
        menu.center = self.view.center;
        menu.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.5
                         animations:^{
                             menu.transform = CGAffineTransformIdentity;
                         }];
        menu.contentView = VC.view;
    }else{
        YWInViewController *VC = [[YWInViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}


//点击左边的按钮
- (void)leftClick:(YlListButton *)sender{
    //弹出蒙版
    cover = [YWCover show];
    cover.delegate = self;
    [cover setDimBackground:YES];
    
    // 弹出pop菜单
    CGFloat popX = 33;
    CGFloat popH = 338;
    CGFloat popY = 150;
    YWPopView *menu = [YWPopView showInRect:CGRectMake(popX, popY, kScreenWidth-66, popH)];
    menu.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.5
                     animations:^{
                         menu.transform = CGAffineTransformIdentity;
                     }];
    menu.contentView = self.leftView.view;
}

//点击蒙版的时候调用
- (void)coverDidClickCover:(YWCover *)cover
{
    // 隐藏pop菜单
    [YWPopView hide];
}

//点击左边的总监，经理等
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏蒙版
    [cover removeFromSuperview];
    [self coverDidClickCover:cover];

    YWNextViewController *VC = [[YWNextViewController alloc]init];
    NSArray *array = @[@"总裁",@"总监",@"经理"];
    VC.title = array[indexPath.row];
    VC.style = indexPath.row+1;
    [self.navigationController pushViewController:VC animated:YES];
}


//设置
- (void)clickSetting{
    YWSettingTableController *settingVC = [[YWSettingTableController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

//点击功能按钮
-(void)clickButton:(NSInteger)number{
    if (number == 6 || number == 7 ) {
        NSArray *array = @[@"转账记录",@"充值记录"];
        YWListViewController *listVC = [[YWListViewController alloc]init];
        listVC.type = [NSString stringWithFormat:@"%ld",number-2];
        listVC.title = array[number-6];
        [self.navigationController pushViewController:listVC animated:YES];
    }else if (number == 4 || number == 5 ) {
        NSArray *array = @[@"收益记录",@"提现记录",@"转账记录",@"充值记录"];
        YWListViewController *listVC = [[YWListViewController alloc]init];
        listVC.type = [NSString stringWithFormat:@"%ld",number-3];
        listVC.title = array[number-4];
        [self.navigationController pushViewController:listVC animated:YES];
    }else if (number == 3 ){
        YWtransferViewController *transferVC = [[YWtransferViewController alloc]init];
        [self.navigationController pushViewController:transferVC animated:YES];
    }else{
        NSArray *array = @[@"我的订单",@"帮我代付",@"我要代付"];
        YWOrderViewController *orderVC = [[YWOrderViewController alloc]init];
        orderVC.type = [NSString stringWithFormat:@"%ld",number+1];
        orderVC.title = array[number];
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[login MD5Digest],sKey]MD5Digest];
    parameter[@"mbh"] = [[[NSString stringWithFormat:@"50%@",user.ID] dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    parameter[@"mpd"] = user.logpwd;
    //每次切换到该界面的时候，就会自动的刷新个人中心的界面
    [YWHttptool Post:YWLogin parameters:parameter success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            YWUser *user = [YWUser yw_objectWithKeyValues:responseObject[@"result"]];
            [YWUserTool saveAccount:user];
            if ([Utils isNull:user.username]) {
                name_label.text = user.wxname;
            }else{
                name_label.text = user.username;
            }
            NSString *str1 = [NSString stringWithFormat:@"蚁币    %@",user.chmoney];
            NSRange range1 = [str1 rangeOfString:@"蚁币    "];
            
            NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:str1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25.f],
                                                                                                                    NSForegroundColorAttributeName:KthemeColor}];
            [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range1];
            [string1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range1];
            ant_number.attributedText = string1;
        }
        
    } failure:^(NSError *error) {
    }];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
