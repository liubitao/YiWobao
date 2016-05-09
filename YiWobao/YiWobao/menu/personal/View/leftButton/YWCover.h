//
//  YWCover.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWCover;

@protocol YWCoverDelegate <NSObject>

//点击蒙版的时候调用
-(void)coverDidClickCover:(YWCover *)cover;


@end


@interface YWCover : UIView
//显示蒙版
+(instancetype)show;

//设置浅色蒙版
@property (nonatomic, assign) BOOL dimBackground;

@property (nonatomic, assign) id  <YWCoverDelegate> delegate;
@end
