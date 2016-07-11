//
//  YWPopView.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWPopView.h"
#import "UIImage+YWimage.h"
#import "YWCover.h"
@implementation YWPopView

// 显示弹出菜单
+ (instancetype)showInRect:(CGRect)rect
{
    YWPopView *menu = [[YWPopView alloc] initWithFrame:rect];
    menu.userInteractionEnabled = YES;
    [YWKeyWindow addSubview:menu];
    if (rect.size.height == 0) {
        [menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(YWKeyWindow);
            make.left.equalTo(YWKeyWindow).with.offset(30);
            make.right.equalTo(YWKeyWindow).with.offset(-30);
            make.height.mas_equalTo(@220);
        }];
    }
  
    
    return menu;
}

// 隐藏弹出菜单
+ (void)hide{
    for (UIView *popMenu in YWKeyWindow.subviews) {
        if ([popMenu isKindOfClass:self]) {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 popMenu.transform = CGAffineTransformMakeScale(0.01, 0.01);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [popMenu removeFromSuperview];
                                 }
                             }];
        }
    }
}

// 设置内容视图
- (void)setContentView:(UIView *)contentView
{
    // 先移除之前内容视图
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:contentView];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算内容视图尺寸
    CGFloat y = 9;
    CGFloat margin = 5;
    CGFloat x = margin;
    CGFloat w = self.width - 2 * margin;
    CGFloat h = self.height - y - margin;
    
    _contentView.frame = CGRectMake(x, y, w, h);
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
