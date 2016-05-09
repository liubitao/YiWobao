//
//  YWFunctionCell.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/3.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWFunctionCell.h"

@implementation YWFunctionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 1.创建子视图
        
        CGFloat itemWidth = CGRectGetWidth(frame);
        CGFloat itemHeight = CGRectGetHeight(frame);
        
        _itemImage = [[UIImageView alloc] initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:itemWidth/2.0 - 22/2.0 Y:10.f width:22.f height:20.f]];
        // 设置图片显示模式
        _itemImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_itemImage];
        
        // 标题
        _itemLabel = [[UILabel alloc] initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:0 Y:itemHeight-20 width:itemWidth height:20.f]];
        _itemLabel.textColor = [UIColor whiteColor];
        _itemLabel.font = [UIFont systemFontOfSize:10.f];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [self addSubview:_itemLabel];
    }
    return self;
}

- (void)configureCellWithModel:(NSDictionary *)model{
    _itemImage.image = [UIImage imageNamed:model[@"image"]];
    _itemLabel.text = model[@"title"];
}




@end
