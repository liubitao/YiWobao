//
//  YWLoginViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/5.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWLoginViewController.h"
#import <AFNetworking.h>
#import "Utils.h"
#import <MBProgressHUD.h>
#import "YWHttptool.h"
#import <NSString+MD5.h>
#import "YWmainViewController.h"
#import "YWUser.h"
#import "YWUserTool.h"

@interface YWLoginViewController ()<UIGestureRecognizerDelegate>
{
    MBProgressHUD *_hudView;
    UIView *bgView;
    UITextField *_phone;
    UITextField *_passWord;
}
@end

@implementation YWLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    self.view.backgroundColor = KviewColor;
    
    [self createLeftButton];
    
    [self createTextFields];
    
    [self createButton];
    
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gesture];
}

- (void)createLeftButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self  action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem = item;
    
}
-(void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createButton{
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 37) backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(landClick)];
    landBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:122/255.0 blue:33/255.0 alpha:1];
    landBtn.layer.cornerRadius = 5.0f;
    
    [self.view addSubview:landBtn];

}

-(void)createTextFields{
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 75, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.alpha=0.7;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _phone=[self createTextFielfFrame:CGRectMake(60, 10, 271, 30) font:14 placeholder:@"请输入编号"];
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _passWord =[self createTextFielfFrame:CGRectMake(60, 60, 271, 30) font:14  placeholder:@"密码" ];
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    _passWord.secureTextEntry=YES;
    
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(20, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.5]];
    
    [bgView addSubview:_phone];
    [bgView addSubview:_passWord];
    
    [bgView addSubview:userImageView];
    [bgView addSubview:pwdImageView];
    [bgView addSubview:line1];
}

//登录
-(void)landClick{
    _hudView = [Utils createHUD];
    _hudView.userInteractionEnabled = NO;
    _hudView.labelText = @"正在登录";
    [_hudView hide:YES afterDelay:1];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[login MD5Digest],sKey]MD5Digest];
    parameter[@"mbh"] = [[_phone.text dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    parameter[@"mpd"] = [_passWord.text MD5Digest];

    [YWHttptool Post:YWLogin parameters:parameter success:^(id responseObject) {
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            YWUser *user = [YWUser yw_objectWithKeyValues:responseObject[@"result"]];
            [YWUserTool saveAccount:user];
            YWmainViewController *mainVC = [[YWmainViewController alloc]init];
            [self presentViewController:mainVC animated:YES completion:nil];
            return ;
        }
        //输入密码错误
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"用户名或密码不正确";
    
    } failure:^(NSError *error) {
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"网络异常，请检查网络";
    }];
}


-(UITextField *)createTextFielfFrame:(CGRect)frame font:(CGFloat )font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
   
    textField.font = [UIFont boldSystemFontOfSize:font];
    
    textField.textColor = [UIColor grayColor];
    
    textField.borderStyle = UITextBorderStyleNone;
    
    textField.placeholder = placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
//确定这个手势是否可以实现
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //判断这个账号和密码控件中是否都是第一响应者
    if (![_phone isFirstResponder] && ![_passWord isFirstResponder]) {
        //都不是第一响应者的时候
        return NO;
    }
    return YES;
}

//隐藏键盘栏
- (void)hidenKeyboard
{
    [_phone resignFirstResponder];
    [_passWord resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
