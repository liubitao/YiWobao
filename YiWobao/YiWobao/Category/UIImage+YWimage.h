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


- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

/**
 *  将图片 裁剪成圆角效果
 *
 *  @param imageName    图片名
 *  @param cornerRadius 圆角半径
 *  @param borderWidth  边框宽度
 *  @param borderColor  边框颜色
 *
 *  @return 剪裁之后的图片
 */
+(UIImage *)roundImageWithImageName:(NSString *)imageName
                       cornerRadius:(CGFloat)cornerRadius
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor;
@end
