//
//  YWmainItemButton.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/4.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWmainItemButton.h"

@implementation YWmainItemButton


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat h = self.height * 0.5;
    CGFloat w = h;
    CGFloat x = (self.width - w) * 0.5;
    CGFloat y = self.height * 0.2;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.height * 0.7, self.width, self.height * 0.3);
}


@end
