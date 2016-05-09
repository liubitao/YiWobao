 /*
 The File Name：FrameAutoScaleLFL.m
 The Creator  ：Created by DragonLi
 Creation Time：On 15/11/14.
 Copyright    ：  Copyright © 2015年 李夫龙. All rights reserved.
 File Content Description：
 */
/** cell的10宽度常量  */

#import "FrameAutoScaleLFL.h"

@implementation FrameAutoScaleLFL

static FrameAutoScaleLFL *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (instancetype)sharedFrameAutoScaleLFL{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
        
    });
    
    return SINGLETON;
}
- (instancetype) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    [self AutoSizeScale];
    self = [super init];
    return self;
}

#pragma mark - Life Cycle

+ (instancetype) allocWithZone:(NSZone *)zone
{
    return [self sharedFrameAutoScaleLFL];
}


- (id)initWithAutoSizeScaleX:(float)autoSizeScaleX
              AutoSizeScaleY:(float )autoSizeScaleY{
    self = [super init];
    if (self) {
        _autoSizeScaleX = autoSizeScaleX;
        _autoSizeScaleY = autoSizeScaleY;
    }
    
    return self;
}


- (void)setWithAutoSizeScaleX:(float)autoSizeScaleX{
    _autoSizeScaleX = autoSizeScaleX;
}

- (void)setWithAutoSizeScaleY:(float)autoSizeScaleY{
    _autoSizeScaleY = autoSizeScaleY;
}
- (float)autoSizeScaleX{
    return _autoSizeScaleX;
}
- (float)autoSizeScaleY{
    return _autoSizeScaleY;
}

#pragma mark ----storyBorad Xib AutoLayouts
/**
 *   storyBoard中得view自动适配
 *  @param storyBoradClassName 需要适配的storyBorad类名.
 */
+ (void)storyBoradLFLAutoLayoutsWithstoryBoradClassName:(NSString *)storyBoradClassName
{
    [self scaleAutoLayouts: [[UIViewController alloc] initWithNibName:storyBoradClassName bundle:nil].view ];
}

/**
 *   Xib中得view自动适配
 *  @param NibClassName 需要适配的xib类名
 */
+ (void)xibLFLAutoLayoutsWithNibClassName:(NSString *)NibClassName
{
    [self scaleAutoLayouts:[[[NSBundle mainBundle] loadNibNamed: NibClassName owner:nil options:nil]firstObject]];
}
/**
 *可视化的缩放适配
 *  @param LayoutsBaseView 需要适配的控件添加的父类view
 */
+ (void)scaleAutoLayouts:(UIView *)LayoutsBaseView{
    for (UIView *viewLFL in LayoutsBaseView.subviews) {
        viewLFL.frame = [FrameAutoScaleLFL CGLFLMakeX:viewLFL.frame.origin.x Y:viewLFL.frame.origin.y width:viewLFL.frame.size.width height:viewLFL.frame.size.height];
        if (viewLFL.subviews.count) {
            [self scaleAutoLayouts:LayoutsBaseView];
        }
    }
}


#pragma mark -CGRect
/**
 返回一个进过处理缩放比例的frame
 */
+ (CGRect)CGLFLMakeX:(CGFloat) x Y:(CGFloat) y width:(CGFloat) width height:(CGFloat) height{
    return CGLFLMake(x, y, width, height);
}
/**
 返回一个全屏幕的 frame
 */
+ (CGRect)CGLFLfullScreen{
    return CGLFLMake(0, 0, RealUISrceenWidth, RealUISrceenHight);
}
#pragma mark CGPoint
+ (CGPoint)CGLFLPointMakeX:(CGFloat) x Y:(CGFloat) y{
    return CGPointLFLMake(x, y);
}
#pragma mark CGsize
+ (CGSize)CGSizeLFLMakeWidth:(CGFloat) widthLFL hight:(CGFloat) hightLFL{
    return CGSizeLFLMake(widthLFL, hightLFL);
}
+ (CGSize)CGSizeLFLMakeMainScreenSize{
    return CGSizeLFLMake( RealUISrceenWidth, RealUISrceenHight);
}

#pragma mark 重写CGRectMake方法
/**
 重写CGRectMake 方法
 */
CG_INLINE CGRect
CGLFLMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    
    FrameAutoScaleLFL *LFL = [FrameAutoScaleLFL sharedFrameAutoScaleLFL];
    CGRect rect;
    rect.origin.x = x *LFL.autoSizeScaleX;
    rect.origin.y = y * LFL.autoSizeScaleY;
    rect.size.width = width * LFL.autoSizeScaleX;
    rect.size.height = height * LFL.autoSizeScaleY;
    return rect;
}
/**
 重写CGPoint 方法
 */
CG_INLINE CGPoint
CGPointLFLMake(CGFloat x, CGFloat y)
{
    FrameAutoScaleLFL *LFL = [FrameAutoScaleLFL sharedFrameAutoScaleLFL];
    CGPoint pointLFL;
    pointLFL.x = x * LFL.autoSizeScaleX;
    pointLFL.y = y * LFL.autoSizeScaleY;
    return pointLFL;
}
/**
 重写CGSize 方法
 */
CG_INLINE CGSize
CGSizeLFLMake(CGFloat width, CGFloat height)
{
    FrameAutoScaleLFL *LFL = [FrameAutoScaleLFL sharedFrameAutoScaleLFL];
    CGSize sizeLFL;
    sizeLFL.width = width* LFL.autoSizeScaleX;
    sizeLFL.height = height* LFL.autoSizeScaleY;
    return sizeLFL;
}
#pragma mark------计算一次缩放比例
- (void)AutoSizeScale{
    
    _autoSizeScaleX = kScreenWidth/RealUISrceenWidth;
    _autoSizeScaleY = KscreenHeight/RealUISrceenHight;
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com