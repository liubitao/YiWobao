//
//  YWWriterViewController.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/9.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWWriterViewController.h"

@interface YWWriterViewController ()
{
    UITextField *_textField;
}
@end

@implementation YWWriterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KviewColor;
    
    [self createSubViews];
}

-(void)createSubViews{
    
    UIBarButtonItem *right_btn = [[UIBarButtonItem alloc]initWithTitle:@"确定 " style:UIBarButtonItemStylePlain target:self action:@selector(popTonext)];
    self.navigationItem.rightBarButtonItem = right_btn;
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 74, kScreenWidth-20, 30)];
    _textField.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,29,kScreenWidth, 1)];
    view.backgroundColor = [UIColor orangeColor];
    [_textField addSubview:view];
    _textField.placeholder = @"请输入内容";
    _textField.font = [UIFont systemFontOfSize:14];
    [_textField becomeFirstResponder];
    [self.view addSubview:_textField];
}

-(void)returnText:(ReturnTextBlock)block{
    self.returnTextBlock=block;
    
}

-(void)popTonext{
    //相当于是给returnTextBlock的参数赋值
    if (self.returnTextBlock!=nil) {
        NSString * str = _textField.text;
        //调用了这个block
        self.returnTextBlock(str);
    }
    
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
