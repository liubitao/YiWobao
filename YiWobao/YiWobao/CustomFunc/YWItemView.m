//
//  YWItemView.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/27.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWItemView.h"

@interface YWItemView (){
    
    UILabel *_itemLabel;          //标题文本
    UIImageView *_itemImageView;  //按钮图片
    
}

@end

@implementation YWItemView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //创建子视图
        
        CGFloat itemWidth = CGRectGetWidth(frame);
        CGFloat itemHeight = CGRectGetHeight(frame);
        
        //设置图片
        _itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(itemWidth/5, 9, 31, 31)];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_itemImageView];
        
        //设置标题
        _itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(itemWidth/2-15, 10, itemWidth/2, itemHeight-18)];
        _itemLabel.textColor = [UIColor grayColor];
        _itemLabel.font = [UIFont systemFontOfSize:19];
        _itemLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_itemLabel];

    }
    return self;
}



//设置图片
-(void)setItemImage:(NSString *)imageName forControlState:(UIControlState)state{
    if (state == UIControlStateNormal) {
        _itemImageView.image = [UIImage imageNamed:imageName];
    }else if (state == UIControlStateSelected){
        _itemImageView.highlightedImage = [UIImage imageNamed:imageName];
    }

    
}

//设置标题
- (void)setItemTitle:(NSString *)title withSpecialTextColor:(UIColor *)color{
    _itemLabel.text = title;
    _itemLabel.highlightedTextColor = color;
    
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    //当按下按钮被选中的时候
    _itemImageView.highlighted = selected;
    _itemLabel.highlighted = selected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
