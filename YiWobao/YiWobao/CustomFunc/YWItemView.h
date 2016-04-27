//
//  YWItemView.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/27.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWItemView : UIControl

//设置图片
-(void)setItemImage:(NSString *)imageName forControlState:(UIControlState)state;

//设置标题
- (void)setItemTitle:(NSString *)title
withSpecialTextColor:(UIColor *)color;

@end
