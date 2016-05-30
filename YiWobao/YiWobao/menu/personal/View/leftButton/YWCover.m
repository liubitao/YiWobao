//
//  YWCover.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWCover.h"

@implementation YWCover

//设置浅色的蒙版
- (void)setDimBackground:(BOOL)dimBackground{
    _dimBackground = dimBackground;
    if (dimBackground) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
    }
    else{
        self.alpha = 0.5;
        self.backgroundColor = [UIColor whiteColor];
    }
}

//显示蒙版
+ (instancetype)show{
    YWCover *cover = [[YWCover alloc]initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor clearColor];
    [YWKeyWindow addSubview:cover];
    return cover;
}

// 点击蒙板的时候做事情
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 移除蒙板
    [self removeFromSuperview];
    
    // 通知代理移除菜单
    if ([_delegate respondsToSelector:@selector(coverDidClickCover:)]) {
        
        [_delegate coverDidClickCover:self];
        
    }
    
}
@end
