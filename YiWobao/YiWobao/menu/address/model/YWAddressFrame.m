//
//  YWAddressFrame.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWAddressFrame.h"
#import "YWAddressModel.h"


@implementation YWAddressFrame

- (void)setModel:(YWAddressModel *)model{
    _model = model;
    
    //计算尺寸
    _nameFrame = CGRectMake(20, 10, 150, 30);
    _phoneFrame = CGRectMake(kScreenWidth-170, 10, 150, 30);
    
    UIFont *nameFont = [UIFont systemFontOfSize:14.f]; //字体的大小
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:nameFont,NSFontAttributeName, nil];
    
    CGRect rect = [[NSString stringWithFormat:@"%@%@%@%@",model.addr1,model.addr2,model.addr3,model.addr4] boundingRectWithSize:CGSizeMake(kScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    _addressFrame = CGRectMake(20, 45, kScreenWidth-20, CGRectGetHeight(rect));
    
    //默认地址的尺寸
    _defalutFrame = CGRectMake(0, 60+CGRectGetHeight(rect), 120, 30);
    
    _editorFrame = CGRectMake(kScreenWidth-90, 60+CGRectGetHeight(rect), 30, 30);
    _deleteFrame = CGRectMake(kScreenWidth-40, 60+CGRectGetHeight(rect), 30, 30);
    
    _cellHeight = 95+CGRectGetHeight(rect);
    
}


@end
