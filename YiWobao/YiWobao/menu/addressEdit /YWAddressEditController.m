//
//  YWAddressEditController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWAddressEditController.h"
#import "YWUserTool.h"
#import "YWUser.h"
#import "YWHttptool.h"
#import "Utils.h"
#import "YWAddressModel.h"
#import "CityPickView.h"
#import <MBProgressHUD.h>

@interface YWAddressEditController ()<UIGestureRecognizerDelegate,CityPickViewDelegate,UITextViewDelegate>{
    UITextField *name_text;
    UITextField *phone_text;
    UILabel *address;
    MBProgressHUD *_hudView;
    
}
@property (nonatomic,strong) NSDictionary *pickerDic;

@property (nonatomic,strong) CityPickView *pickView;
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
    UILabel *name_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 74, 80, 30)];
    name_label.font = [UIFont systemFontOfSize:16];
    name_label.text = @"收货人";
    [self.view addSubview:name_label];
    
    YWUser *user = [YWUserTool account];
    
    name_text = [[UITextField alloc]initWithFrame:CGRectMake(130, 74, kScreenWidth-150, 30)];
    name_text.text = _addressModel.pickname;
    name_text.font = [UIFont systemFontOfSize:14];
    name_text.textAlignment = NSTextAlignmentRight;
    name_text.borderStyle = UITextBorderStyleNone;
    if (![Utils isNull:user.username]) {
        name_text.text = user.username;
    }else{
        name_text.text = user.wxname;
    }
    
    [self.view addSubview:name_text];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 113,kScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.view addSubview:line1];
    
    //电话
    UILabel *phone_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 124, 80, 30)];
    phone_label.font = [UIFont systemFontOfSize:16];
    phone_label.text = @"联系电话";
  
    [self.view addSubview:phone_label];
    
    phone_text = [[UITextField alloc]initWithFrame:CGRectMake(130, 124, kScreenWidth-150, 30)];
    phone_text.text = _addressModel.pickphone;
    phone_text.font = [UIFont systemFontOfSize:14];
    phone_text.textAlignment = NSTextAlignmentRight;
    phone_text.keyboardType = UIKeyboardTypeNumberPad;
    if (![Utils isNull:user.phone]) {
        phone_text.text = user.phone;
    }
    [self.view addSubview:phone_text];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 163,kScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.view addSubview:line2];
    
    UILabel *address_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 174, 80, 30)];
    address_label.font = [UIFont systemFontOfSize:16];
    address_label.text = @"所在地区";
    [self.view addSubview:address_label];
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(150, 174, kScreenWidth-170, 30)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label];
    address = label;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickAddress)];
    tap.numberOfTapsRequired = 1;
    address.userInteractionEnabled = YES;
    [address addGestureRecognizer:tap];
    
    
    //联系地址
    UILabel *address2_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 214, 80, 30)];
    address2_label.font = [UIFont systemFontOfSize:14];
    address2_label.text = @"所在街道";
    [self.view addSubview:address2_label];
    
    _feedbackTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 254, kScreenWidth-20, 100)];
    _feedbackTextView.delegate = self;
    _feedbackTextView.textColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    if (_addressModel) {
        name_text.text = _addressModel.pickname;
        phone_text.text = _addressModel.pickphone;
        [address setText:[NSString stringWithFormat:@"%@%@%@",_addressModel.addr1,_addressModel.addr2,_addressModel.addr3]];
        _feedbackTextView.text = _addressModel.addr4;
    }else{
        _feedbackTextView.text = @"请填写详细地址，不少于5个字";
    }
    _feedbackTextView.font = [UIFont systemFontOfSize:15];
    _feedbackTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_feedbackTextView];
    _feedbackTextView.backgroundColor = [UIColor whiteColor];
    
    _pickView = [[CityPickView alloc] initWithFrame:CGRectMake(0, KscreenHeight-180, self.view.bounds.size.width, 180)];
    _pickView.backgroundColor = [UIColor yellowColor];
    _pickView.delegate = self;
    [self.view addSubview:_pickView];
    _pickView.hidden = YES;
    
}

- (void)pickAddress{
    [name_text resignFirstResponder];
    [phone_text resignFirstResponder];
    [_feedbackTextView resignFirstResponder];
    _pickView.hidden = NO;
}

- (void)selectCity:(NSString *)city{
    address.text = city;
    _pickView.hidden = YES;
}

- (void)save{
    if (![Utils checkTelNumber:phone_text.text]||[Utils isNull:name_text.text]||[Utils isNull:address.text]||[Utils isNull:_feedbackTextView.text]||[@"请填写详细地址，不少于5个字" isEqualToString:_feedbackTextView.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"填写的资料有误，请重新填写" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
    _hudView = [Utils createHUD];
    _hudView.userInteractionEnabled = NO;
    _hudView.labelText = @"正在修改";
    [_hudView hide:YES afterDelay:2];
    YWUser *user = [YWUserTool account];
    NSMutableDictionary *paramters = [Utils paramter:Addaddr ID:user.ID];
    paramters[@"akd"] = [[self.type dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:0];
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (![Utils isNull:_addressModel]) {
        dict[@"id"] = _addressModel.ID;
    }
    dict[@"pickname"] = name_text.text;
    dict[@"pickphone"] = phone_text.text;
    dict[@"addr1"] = [_pickView.provinceArray objectAtIndex:[_pickView.pickerView selectedRowInComponent:0]];
    dict[@"addr2"] = [_pickView.cityArray objectAtIndex:[_pickView.pickerView selectedRowInComponent:1]];
    dict[@"addr3"] = [_pickView.townArray objectAtIndex:[_pickView.pickerView selectedRowInComponent:2]];
    dict[@"addr4"] = _feedbackTextView.text;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    paramters[@"dzinfo"] = str;
    
    [YWHttptool Post:YWAddaddr parameters:paramters success:^(id responseObject) {
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
        _hudView.labelText = @"修改成功";
        [_hudView hide:YES afterDelay:2];
    } failure:^(NSError *error) {
        _hudView.mode = MBProgressHUDModeCustomView;
        _hudView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        _hudView.labelText = @"网络异常，修改失败";
        [_hudView hide:YES afterDelay:1];
    }];
    [self.navigationController popViewControllerAnimated:YES];
    }
}
/**实现place holder效果,开始编辑时,清除hint
 */
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //	NSLog(@"开始编辑");
    
    if ([textView.text isEqualToString:@"请填写详细地址，不少于5个字"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //	NSLog(@"结束编辑");
    
    if (textView.text.length == 0) {
        textView.text = @"请填写详细地址，不少于5个字";
        textView.textColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    }
}

/**当点击回车时,结束输入,键盘收起
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
