//
//  YWSearchBar.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/27.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWSearchBar.h"

@implementation YWSearchBar


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if(self){
        self.font = [UIFont systemFontOfSize:15];
        UIImage *image = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.background = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        
        //设置左边的view
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        imageV.width +=10;
        imageV.contentMode = UIViewContentModeCenter;
        self.leftView = imageV;
        self.leftViewMode = UITextFieldViewModeAlways;
        //设置return为搜索
        self.returnKeyType = UIReturnKeyGoogle;
        
    }
    return self;
}


- (CGRect)borderRectForBounds:(CGRect)bounds{
    bounds.size.height = 80;
    return bounds;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
