//
//  YWAderssCell.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWAderssCell.h"
#import "YWAddressFrame.h"
#import "YWAddressModel.h"
@interface YWAderssCell ()
@property (weak, nonatomic)  UILabel *name;
@property (weak, nonatomic)  UILabel *phone;
@property (weak, nonatomic)  UILabel *address;

@property (weak, nonatomic)  UIButton *editorButton;
@property (weak, nonatomic)  UIButton *deleteButton;
@property (weak, nonatomic)  UIView *line;

@end

@implementation YWAderssCell



// 手写代码构造
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 选中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 创建子视图
        [self _initSubViews];
    }
    return self;
}
- (void)_initSubViews{
    //创建名字
    UILabel *name_label = [[UILabel alloc]initWithFrame:CGRectZero];
    name_label.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:name_label];
    _name = name_label;
    
    //创建电话
    UILabel *phone_label = [[UILabel alloc]initWithFrame:CGRectZero];
    phone_label.font = [UIFont systemFontOfSize:15];
    phone_label.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:phone_label];
    _phone = phone_label;
    
    //创建地址
    UILabel *address_label = [[UILabel alloc]initWithFrame:CGRectZero];
    address_label.font = [UIFont systemFontOfSize:14];
    address_label.numberOfLines = 0;
    [self.contentView addSubview:address_label];
    _address = address_label;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.contentView addSubview:line];
    _line = line;
    
    //创建默认按钮
    UIButton *default_btn = [[UIButton alloc]initWithFrame:CGRectZero];
    default_btn.tag = 1;
    default_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [default_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [default_btn setTitle:@"默认地址" forState:UIControlStateNormal];
    [default_btn setImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
    [default_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:default_btn];
    _defaultButoon = default_btn;
    
    //创建编辑按钮
    UIButton *editor_btn = [[UIButton alloc]initWithFrame:CGRectZero];
    editor_btn.tag = 2;
    editor_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [editor_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editor_btn setTitle:@"编辑" forState:UIControlStateNormal];
    [editor_btn setImage:[UIImage imageNamed:@"ic_mode_edit"] forState:UIControlStateNormal];
    [editor_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editor_btn];
    _editorButton = editor_btn;
    
    //创建删除按钮
    UIButton *delete_btn = [[UIButton alloc]initWithFrame:CGRectZero];
    delete_btn.tag = 3;
    delete_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [delete_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [delete_btn setTitle:@"删除" forState:UIControlStateNormal];
    [delete_btn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
    [delete_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:delete_btn];
    _deleteButton = delete_btn;

}
//点击
- (void)click:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickCell:tag:)]) {
        [self.delegate clickCell:_indexpath tag:sender.tag];
    }
}

- (void)configModel:(YWAddressFrame *)addressFrame{

    YWAddressModel *model = addressFrame.model;
    _name.frame = addressFrame.nameFrame;
    _name.text = model.name;
    
    _phone.frame = addressFrame.phoneFrame;
    _phone.text = model.phone;
    
    _address.frame = addressFrame.addressFrame;
    _address.text = model.address;
    
    _line.frame = CGRectMake(0, CGRectGetHeight(_address.frame)+55, kScreenWidth, 1);
    
    _defaultButoon.frame = addressFrame.defalutFrame;
    if (model.defualt) {
        [_defaultButoon setImage:[UIImage imageNamed:@"tabbar_profile"] forState:UIControlStateNormal];
    }
    
    _editorButton.frame = addressFrame.editorFrame;
    
    _deleteButton.frame = addressFrame.deleteFrame;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
