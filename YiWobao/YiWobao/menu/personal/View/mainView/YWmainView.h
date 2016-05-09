//
//  YWmainView.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/4.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWFunctionModel.h"

@protocol YWmainViewDelegate <NSObject>

-(void)clickButton:(NSInteger)number;

@end

@interface YWmainView : UIScrollView

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) id <YWmainViewDelegate> mainDelegate;


-(void)config;

@end
