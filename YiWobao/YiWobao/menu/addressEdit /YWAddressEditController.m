//
//  YWAddressEditController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWAddressEditController.h"


@interface YWAddressEditController ()<UIGestureRecognizerDelegate>{
    UITextField *name_text;
    UITextField *phone_text;
}
@property (nonatomic,strong) UITextView *feedbackTextView;
@end

@implementation YWAddressEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KviewColor;
    
    //创建UI
    [self createUI];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gesture];
    
}

- (void)createUI{
    //右边的按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    //联系人
    UILabel *name_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 74, 60, 30)];
    name_label.font = [UIFont systemFontOfSize:14];
    name_label.text = @"收货人";
    [self.view addSubview:name_label];
    
    name_text = [[UITextField alloc]initWithFrame:CGRectMake(200, 74, kScreenWidth-240, 30)];
    name_text.text = _name;
    name_text.font = [UIFont systemFontOfSize:14];
    name_text.textAlignment = NSTextAlignmentRight;
    name_text.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:name_text];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 113,kScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.view addSubview:line1];
    
    //电话
    UILabel *phone_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 124, 60, 30)];
    phone_label.font = [UIFont systemFontOfSize:14];
    phone_label.text = @"联系电话";
    [self.view addSubview:phone_label];
    
    phone_text = [[UITextField alloc]initWithFrame:CGRectMake(100, 124, kScreenWidth-140, 30)];
    phone_text.text =_phone;
    phone_text.font = [UIFont systemFontOfSize:14];
    phone_text.textAlignment = NSTextAlignmentRight;
    phone_text.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:phone_text];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 163,kScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.view addSubview:line2];
    
    //联系地址
    UILabel *address_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 164, 60, 30)];
    address_label.font = [UIFont systemFontOfSize:14];
    address_label.text = @"联系地址";
    [self.view addSubview:address_label];
    
    _feedbackTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 204, kScreenWidth-20, 100)];
    if (_address) {
        _feedbackTextView.text = _address;
    }else{
        _feedbackTextView.text = @"请填写详细地址，不少于5个字";
    }
    _feedbackTextView.font = [UIFont systemFontOfSize:15];
    _feedbackTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_feedbackTextView];
    _feedbackTextView.backgroundColor = [UIColor whiteColor];
    
}

- (void)save{
    YWLog(@"保存");
    [self.navigationController popViewControllerAnimated:YES];
}

//确定这个手势是否可以实现
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //判断这个账号和密码控件中是否都是第一响应者
    if (![name_text isFirstResponder] && ![phone_text isFirstResponder]&&![_feedbackTextView isFirstResponder]) {
        //都不是第一响应者的时候
        return NO;
    }
    return YES;
}

//隐藏键盘栏
- (void)hidenKeyboard
{
    [name_text resignFirstResponder];
    [phone_text resignFirstResponder];
    [_feedbackTextView resignFirstResponder];
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
