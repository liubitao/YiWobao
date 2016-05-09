//
//  YWPopView.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPopView : UIImageView

//显示弹出菜单
+(instancetype)showInRect:(CGRect)rect;

/**
 *  隐藏弹出菜单
 */
+ (void)hide;

// 内容视图
@property (nonatomic, weak) UIView *contentView;

@end
