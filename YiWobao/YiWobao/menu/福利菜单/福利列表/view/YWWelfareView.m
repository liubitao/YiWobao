//
//  YWWelfareView.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/22.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWWelfareView.h"

@implementation YWWelfareView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    //1.获取图形上下文
         CGContextRef ctx=UIGraphicsGetCurrentContext();
    
        //2.绘图
         //2.a 画一条直线
         //2.a.1创建一条绘图的路径
         //注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
         CGMutablePathRef path=CGPathCreateMutable();
    
         //2.a.2把绘图信息添加到路径里
         CGPathMoveToPoint(path, NULL, 0 , 20);
         CGPathAddLineToPoint(path, NULL, 5, 20);
         CGPathAddLineToPoint(path, NULL, 5, 25);
         CGPathCloseSubpath(path);
    
    
         //2.a.3把路径添加到上下文中
         //把绘制直线的绘图信息保存到图形上下文中
         CGContextAddPath(ctx, path);
    CGContextSetFillColorWithColor(ctx, _color.CGColor);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
         //2.b画一个圆
         //2.b.1创建一条画圆的绘图路径(注意这里是可变的，不是CGPathRef)
         CGMutablePathRef path1=CGPathCreateMutable();
    
         //2.b.2把圆的绘图信息添加到路径里
         CGPathAddRect(path1, NULL, CGRectMake(0,0, 70 , 20));
    
         //2.b.3把圆的路径添加到图形上下文中
         CGContextAddPath(ctx, path1);
    
    
         //3.渲染
    UIColor *color = [_color colorWithAlphaComponent:0.7];
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextDrawPath(ctx, kCGPathFillStroke);
         //4.释放前面创建的两条路径
         //第一种方法
         CGPathRelease(path);
         CGPathRelease(path1);
   
    
}

- (void)setColor:(UIColor *)color{
    _color = color;
    [self setNeedsDisplay];
}


@end
