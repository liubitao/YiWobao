//
//  XYLScanView.m
//  XYLScaningCode
//
//  Created by 薛银亮 on 16/2/22.
//  Copyright © 2016年 薛银亮. All rights reserved.
//

#import "XYLScanView.h"

#define GH_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define GH_HEIGHT   [[UIScreen mainScreen] bounds].size.height


@implementation XYLScanView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置 背景为clear
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor colorWithWhite:0 alpha:0.5] setFill];
    //半透明区域
    UIRectFill(rect);
    
    //透明的区域
    CGRect holeRection = CGRectMake((GH_WIDTH*0.5f)/2,GH_HEIGHT*0.2f,GH_WIDTH*0.5f,GH_WIDTH*0.5f);
    /** union: 并集
     CGRect CGRectUnion(CGRect r1, CGRect r2)
     返回并集部分rect
     */
    
    /** Intersection: 交集
     CGRect CGRectIntersection(CGRect r1, CGRect r2)
     返回交集部分rect
     */
    CGRect holeiInterSection = CGRectIntersection(holeRection, rect);
    [[UIColor clearColor] setFill];
    
    //CGContextClearRect(ctx, <#CGRect rect#>)
    //绘制
    //CGContextDrawPath(ctx, kCGPathFillStroke);
    UIRectFill(holeiInterSection);
    
}



- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect
{
    /**
     *  绘制rect路径
     Quartz uses the line width and stroke color of the graphics state to paint the path. As a side effect when you call this function, Quartz clears the current path:解释：Quartz使用指定线宽和颜色来绘制路径，但是有一个副作用 就是绘制前会清空之前的路径
     */
    CGContextStrokeRect(ctx, rect);
    /**
     *  绘制刚才的路径的颜色
     Quartz sets the current stroke color to the value specified by the red, green, blue, and alpha parameters.解释：使用提供的红绿蓝透明度来绘制指定的路径
     */
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    /**
     *  设置线宽
     */
    CGContextSetLineWidth(ctx, 0.8);
    /**
     *  把画出的图形添加到上下文
     This is a convenience function that adds a rectangle to a path：添加矩形到上下文
     */
    CGContextAddRect(ctx, rect);
    /**
     *  开始绘制图片
     */
    CGContextStrokePath(ctx);
}
@end
