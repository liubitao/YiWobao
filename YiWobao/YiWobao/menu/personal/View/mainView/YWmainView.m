//
//  YWmainView.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/4.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWmainView.h"
#import "YWFunctionModel.h"
#import "YWmainItemButton.h"

@implementation YWmainView


-(void)config{
    
    CGFloat buttonWidth = 375/4.0;
    CGFloat buttonHeight = buttonWidth;
    [self.dataArray enumerateObjectsUsingBlock:^(YWFunctionModel *obj, NSUInteger idx, BOOL *stop) {
        YWFunctionModel *model = self.dataArray[idx];
        
        CGFloat buttonX = (idx % 4) * buttonWidth;
        CGFloat buttonY = (idx / 4) * buttonHeight;
      
        YWmainItemButton *button = [YWmainItemButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = [FrameAutoScaleLFL CGLFLMakeX:buttonX Y:buttonY width:buttonWidth height:buttonHeight];;
        button.tag = idx;
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageStr = model.imageString;
        [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [button setTitle:model.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if ((idx+1)%4 != 0) {
            
            UIView *separatar = [[UIView alloc] initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:buttonWidth-0.5 Y:0 width:0.5 height:buttonHeight]];
            separatar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            [button addSubview:separatar];
        }
      
        if (4 > 1 && idx/4 < (4-1)) {
            
            UIView *separatar = [[UIView alloc] initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:buttonHeight-0.5 width:buttonWidth height:0.5]];
            separatar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            [button addSubview:separatar];
        }
    }];
  
}
-(void)buttonTapped:(YWmainItemButton *)sender{
    if ([self.mainDelegate respondsToSelector:@selector(clickButton:)]) {
        [self.mainDelegate clickButton:sender.tag];
    }
}
@end
