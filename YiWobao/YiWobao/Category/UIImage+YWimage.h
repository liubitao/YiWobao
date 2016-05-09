//
//  UIImage+YWimage.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YWimage)

// instancetype默认会识别当前是哪个类或者对象调用，就会转换成对应的类的对象
// UIImage *

// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

+ (UIImage *)imageWithColor:(UIColor *)color;


@end
