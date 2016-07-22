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
#import "MBProgressHUD+MJ.h"
#import "YWHttptool.h"
#import <NSString+MD5.h>
#import "YWmainViewController.h"
#import "YWUser.h"
#import "YWUserTool.h"
#import "RegisterController.h"

@interface YWLoginViewController ()<UIGestureRecognizerDelegate>
{
    UIView *bgView;
    UITextField *_phone;
    UITextField *_passWord;
}
@end

@implementation YWLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
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
    UIButton *left_btn = [[UIButton alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:40 width:70 height:14]];
    left_btn.titleLabel.text = @"蚁窝宝";
    [left_btn setTitle:@"蚁窝宝" forState:UIControlStateNormal];
    [left_btn setTitleColor:[UIColor colorWithHexString:@"C9C9CA"] forState:UIControlStateNormal];
    [left_btn addTarget:self  action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left_btn];
}

-(void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createButton{
    UIButton *landBtn=[self createButtonFrame:[FrameAutoScaleLFL CGLFLMakeX:20 Y:290 width:335 height:32] backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  target:self action:@selector(landClick)];
    landBtn.backgroundColor = KthemeColor;
    landBtn.layer.cornerRadius = 5.0f;
    
    [self.view addSubview:landBtn];

}

-(void)createTextFields{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:142 Y:81 width:77 height:77]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"icon"];
    [self.view addSubview:imageView];
    
    bgView=[[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:177 width:375 height:84]];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"717071" withAlpha:0.5];
    [bgView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height-0.5, kScreenWidth, 0.5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"717071" withAlpha:0.5];
    [bgView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:18 Y:41 width:375-36 height:0.5]];
    line3.backgroundColor = [UIColor colorWithHexString:@"717071" withAlpha:0.5];
    [bgView addSubview:line3];
    
    
    _phone=[self createTextFielfFrame:[FrameAutoScaleLFL CGLFLMakeX:65 Y:10 width:375-65-18 height:20] placeholder:@"请输入您的编号"];
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _passWord =[self createTextFielfFrame:[FrameAutoScaleLFL CGLFLMakeX:65 Y:50 width:375-65-18 height:20]  placeholder:@"请输入密码" ];
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    _passWord.secureTextEntry=YES;
    
    UIImageView *userImageView=[self createImageViewFrame:[FrameAutoScaleLFL CGLFLMakeX:25 Y:10 width:20 height:20] imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:[FrameAutoScaleLFL CGLFLMakeX:25 Y:50 width:20 height:20] imageName:@"mm_normal" color:nil];

    
    [bgView addSubview:_phone];
    [bgView addSubview:_passWord];
    
    [bgView addSubview:userImageView];
    [bgView addSubview:pwdImageView];
}

//登录
-(void)landClick{
    [MBProgressHUD showMessage:@"正在登陆"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mKey"] = [[NSString stringWithFormat:@"%@%@",[login MD5Digest],sKey]MD5Digest];
    parameter[@"mbh"] = [[_phone.text dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
    parameter[@"mpd"] = [_passWord.text MD5Digest];

    [YWHttptool Post:YWLogin parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUD];
        NSInteger isError = [responseObject[@"isError"] integerValue];
        if (!isError) {
            YWUser *user = [YWUser yw_objectWithKeyValues:responseObject[@"result"]];
            [YWUserTool saveAccount:user];
            YWmainViewController *mainVC = [[YWmainViewController alloc]init];
            [self presentViewController:mainVC animated:YES completion:nil];
            return ;
        }
        //输入密码错误
        [MBProgressHUD showError:@"用户名和密码有误"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络"];
    }];
}


-(UITextField *)createTextFielfFrame:(CGRect)frame  placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.textColor = [UIColor grayColor];
    
    textField.borderStyle = UITextBorderStyleNone;
    
    textField.font = [UIFont systemFontOfSize:textField.height-5];
    
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

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
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
