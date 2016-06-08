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




@interface YWpersonalViewController ()<YWCoverDelegate,YWLeftDelegate,YWmainViewDelegate,UMSocialUIDelegate>{
    UILabel *ant_number;
    UILabel *name_label;
    YWCover *cover;
}

@property (nonatomic,strong) NSArray *functionData;

@property (nonatomic,strong) YWLeftViewController *leftView;

@property (nonatomic,weak) YlListButton *leftButton;

@property (strong, nonatomic) YWmainView *menu;



@end

@implementation YWpersonalViewController


-(YWLeftViewController*)leftView{
    if (_leftView == nil) {
        _leftView = [[YWLeftViewController alloc]init];
        _leftView.delegate = self;
        _leftView.dataArray = @[@"我的推荐人",@"总裁",@"总监",@"经理"];
    }
    return _leftView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    YWUser *user = [YWUserTool account];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.userimg]]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:0 width:kScreenWidth height:290]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [Utils coreBlurImage:image withBlurNumber:0.5];
    imageView.clipsToBounds=YES;
    [self.view addSubview:imageView];
    
    //创建上面的视图
    [self createHead];
    //创建中间的视图
    [self createUser];
    //创建钱币UI
    [self creatAntUI];
    //创建功能按钮
    [self creatFunctionButton];
    
}
//创建上面的视图
- (void)createHead{
    //左边的按钮
    YlListButton *leftbutton = [YlListButton buttonWithType:UIButtonTypeCustom];
    _leftButton = leftbutton;
    leftbutton.frame = CGRectMake(20, 30, 80, 40);
    [self.view addSubview:leftbutton];
    [leftbutton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    [leftbutton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateSelected];
    [leftbutton setTitle:@"推荐人" forState:UIControlStateNormal];
    //高亮的时候不用变化图片
    leftbutton.adjustsImageWhenHighlighted = NO;
    [leftbutton addTarget:self  action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //右边的按钮
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-40, 30, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"ic_settings"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}
//创建中间的视图
- (void)createUser{
    //判断是否有存储在本地的数据
    YWUser *user = [YWUserTool account];
    
    UIView *headView = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:85 Y:64 width:205 height:220]];
    headView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headView];
    
    //头像
    UIImageView *portrait = [[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:205/2-40 Y:20 width:80 height:80]];
    //设置圆角
    portrait.layer.cornerRadius = 40*kScreenWidth/375;
    [portrait.layer setMasksToBounds:YES];
    [headView addSubview:portrait];
    
    //实业董事
    UILabel *work_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:205/2+40 Y:0 width:80 height:20]];
    work_label.font = [UIFont systemFontOfSize:13];
    work_label.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:work_label];
    
    //昵称
    name_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:105 width:205 height:30]];
    name_label.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:name_label];
    
    //编号
    UILabel *number_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:140 width:205 height:20]];
    number_label.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:number_label];
    
    //七日收益
    UILabel *day_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:165 width:104 height:20]];
    day_label.font = [UIFont systemFontOfSize:14];
    day_label.textAlignment = NSTextAlignmentCenter;
    day_label.text = @"七日收益";
    [headView addSubview:day_label];
    
    //七日收益的数量
    UILabel *day_number = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:190 width:104 height:20]];
    day_number.font = [UIFont systemFontOfSize:16];
    day_number.textAlignment = NSTextAlignmentCenter;
    day_number.textColor = [UIColor redColor];
    [headView addSubview:day_number];
    
    //中间的线
    UIView *line_view = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:104 Y:165 width:1 height:45]];
    line_view.backgroundColor = [UIColor blackColor];
    [headView addSubview:line_view];
    
    //累计收益
    UILabel *all_label = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:105 Y:165 width:104 height:20]];
    all_label.font = [UIFont systemFontOfSize:14];
    all_label.textAlignment = NSTextAlignmentCenter;
    all_label.text = @"累计收益";
    [headView addSubview:all_label];
    
    //累计收益的数量
    UILabel *all_number = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:105 Y:190 width:104 height:20]];
    all_number.font = [UIFont systemFontOfSize:16];
    all_number.textAlignment = NSTextAlignmentCenter;
    all_number.textColor = [UIColor redColor];
    [headView addSubview:all_number];
   
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
        number_label.text = [NSString stringWithFormat:@"编号：%@",user.ID];
        if ([Utils isNull:user.sr_0]) {
            day_number.text = @"+0";
        }else{
            all_number.text = [NSString stringWithFormat:@"+%@",user.sr_0];
        }
        if ([Utils isNull:user.sr_7]) {
            all_number.text = @"+0";
        }
        else{
        day_number.text = [NSString stringWithFormat:@"+%@",user.sr_7];
        }
    }
}
//创建钱币UI
- (void)creatAntUI{
    UIView *ant_view = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:290 width:375 height:50]];
    ant_view.backgroundColor = [UIColor clearColor];
    ant_view.userInteractionEnabled = YES;
    [self.view addSubview:ant_view];
    
    //创建蚁币
    ant_number = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:0 width:375/2 height:50]];
    ant_number.textAlignment = NSTextAlignmentCenter;
    ant_number.font = [UIFont boldSystemFontOfSize:18];
    //判断是否有存储在本地的数据
    YWUser *user = [YWUserTool account];
    if (user) {
        ant_number.text = [NSString stringWithFormat:@"蚁币：%@",user.chmoney];
    }
    [ant_view addSubview:ant_number];
    
    //创建充值
    UIButton *recarge_button = [[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:375/2 Y:0 width:375/4 height:50]];
    recarge_button.tag = 10;
    recarge_button.backgroundColor = [UIColor grayColor];
    [recarge_button setTitle:@"充值" forState:UIControlStateNormal];
    [recarge_button setBackgroundImage:[UIImage imageWithColor:KviewColor] forState:UIControlStateHighlighted];
    [recarge_button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [ant_view addSubview:recarge_button];
    
    
    //创建提现
    UIButton *cashs_button = [[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:375*3/4 Y:0 width:375/4+1 height:50]];
    cashs_button.tag = 20;
    cashs_button.backgroundColor = [UIColor grayColor];
    [cashs_button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [cashs_button setBackgroundImage:[UIImage imageWithColor:KviewColor] forState:UIControlStateHighlighted];
    [cashs_button setTitle:@"提现" forState:UIControlStateNormal];
    [ant_view addSubview:cashs_button];
    
    //创建上下两条线
    UIView *line1 = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:0 width:375 height:1]];
    line1.backgroundColor = [UIColor blackColor];
    [ant_view addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:49 width:375 height:1]];
    line2.backgroundColor = [UIColor blackColor];
    [ant_view addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:375/2-1 Y:0 width:1 height:50]];
    line3.backgroundColor = [UIColor blackColor];
    [ant_view addSubview:line3];
    
    UIView *line4 = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:375*3/4-1 Y:0 width:1 height:50]];
    line4.backgroundColor = [UIColor blackColor];
    [ant_view addSubview:line4];
    
    
    
}
//创建功能按钮
- (void)creatFunctionButton{
    YWmainView *mainView = [[YWmainView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:340 width:375 height:667-340-60]];
    mainView.bounces = NO;
    mainView.scrollEnabled = YES;
    mainView.contentSize = [FrameAutoScaleLFL CGSizeLFLMakeWidth:375 hight:375/4*3];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.mainDelegate = self;
    
    NSArray *array = @[@{@"订单" : @"ic_me_order_72"}, 
                      @{@"帮我代付" : @"ic_help_me_pay_72"},
                       @{@"我要代付" : @"ic_help_other_pay_72.png"},
                       @{@"转账" : @"ic_transfer_accounts_72"},
                       @{@"收益记录" : @"ic_gain_recording_72"},
                       @{@"提现记录" : @"income"},
                       @{@"支出记录":@"ic_withdraw_recording_72"},
                       @{@"转账记录" : @"ic_transfer_accounts_recording_72"},
                       @{@"充值记录" : @"ic_recharge_recording_72"},
                       @{@"转发分享" : @"ic_mall_share_72"},
                       ];
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:9];
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


//充值或提现
- (void)click:(UIButton *)sender{
    if (sender.tag == 10) {
     
    }else{
        YWInViewController *VC = [[YWInViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        YWLog(@"提现");
    }
}

//点击左边的按钮
- (void)leftClick:(YlListButton *)sender{
    sender.selected = !sender.selected;
    
    //弹出蒙版
    cover = [YWCover show];
    cover.delegate = self;
    [cover setDimBackground:NO];
    
    // 弹出pop菜单
    CGFloat popW = 150;
    CGFloat popX = 20;
    CGFloat popH = 200;
    CGFloat popY = 55;
    YWPopView *menu = [YWPopView showInRect:CGRectMake(popX, popY, popW, popH)];
    
    menu.contentView = self.leftView.view;
}

//点击蒙版的时候调用
- (void)coverDidClickCover:(YWCover *)cover
{
    
    // 隐藏pop菜单
    [YWPopView hide];
    _leftButton.selected = NO;
}

//点击左边的总监，经理等
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏蒙版
    [cover removeFromSuperview];
    [self coverDidClickCover:cover];
    
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramter = [Utils paramter:List ID:user.ID];
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    paramter[@"zkd"] = [[str dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    [YWHttptool GET:YWList parameters:paramter success:^(id responseObject) {
        YWLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
    if (indexPath.row == 0){
        YWTjrTableController *VC = [[YWTjrTableController alloc]init];
        VC.title = _leftView.dataArray[indexPath.row];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        
    }
   
}


//设置
- (void)clickSetting{
    YWSettingTableController *settingVC = [[YWSettingTableController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

//点击功能按钮
-(void)clickButton:(NSInteger)number{
    if (number == 4 || number == 5 || number == 6 ||number == 7 || number ==8) {
        NSArray *array = @[@"收益记录",@"提现记录",@"支出记录",@"转账记录",@"充值记录"];
        YWListViewController *listVC = [[YWListViewController alloc]init];
        listVC.type = [NSString stringWithFormat:@"%ld",number-3];
        listVC.title = array[number-4];
        [self.navigationController pushViewController:listVC animated:YES];
    }else if (number == 3 ){
        YWtransferViewController *transferVC = [[YWtransferViewController alloc]init];
        [self.navigationController pushViewController:transferVC animated:YES];
    }else if (number == 9){
        YWUser *user = [YWUserTool account];
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
    else{
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
            ant_number.text = [NSString stringWithFormat:@"蚁币：%@",user.chmoney];
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
