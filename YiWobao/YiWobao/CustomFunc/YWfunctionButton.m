//
//  YWfunctionButton.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/6/17.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWfunctionButton.h"

@implementation YWfunctionButton


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor colorWithHexString:@"8f8f8f"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"FZLanTingHei-L-GBK" size:15];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat h = self.height * 0.6;
    CGFloat w = h;
    CGFloat x = 0;
    CGFloat y = self.height*0.2;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(self.height*0.6, 0, self.width-self.height*0.6, self.height);
}

@end
