//
//  RatingView.m
//  星星视图
//
//  Created by 刘毕涛 on 15/9/2.
//  Copyright (c) 2015年 文华. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView {
    UIView *_grayStarView;    // 灰色星星视图
    UIView *_yellowStarView;  // 黄色星星视图
    UILabel *_ratingLabel;    // 评分标签
    
}

//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    return nil;
//}

// 从IB加载 同样创建星星
- (void)awakeFromNib {
    [self _initSubViews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    
    
    return self;
}

- (void)_initSubViews {
    
    UIImage *grayStarImage = [UIImage imageNamed:@"gray"];
    UIImage *yellowStarImage = [UIImage imageNamed:@"yellow"];
    
    CGFloat imageWidth = grayStarImage.size.width;
    CGFloat imageHeight = grayStarImage.size.height;
    
    // 添加底层 灰色星星
    _grayStarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5 * imageWidth, imageHeight)];
    _grayStarView.backgroundColor = [UIColor colorWithPatternImage:grayStarImage];
    [self addSubview:_grayStarView];
    
    // 覆盖一层黄色星星
    _yellowStarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5 * imageWidth, imageHeight)];
    _yellowStarView.backgroundColor = [UIColor colorWithPatternImage:yellowStarImage];
    [self addSubview:_yellowStarView];
    
    
    // 修改星星的大小
    // 获取父视图 相对于图片的比例
    CGFloat scale = CGRectGetHeight(self.frame) / imageHeight;
    
    CGAffineTransform newTransform = CGAffineTransformMakeScale(scale, scale);
    
    _yellowStarView.transform = newTransform;
    _grayStarView.transform = newTransform;
    
    // 形变是以中心点为基准，变化之后，调整原点位置
    CGRect grayViewRect = _grayStarView.frame;
    grayViewRect.origin = CGPointMake(0, 0);
    _grayStarView.frame = grayViewRect;
    
    CGRect yellowViewRect = _yellowStarView.frame;
    yellowViewRect.origin = CGPointMake(0, 0);
    _yellowStarView.frame = yellowViewRect;
    
    
    
    // 评分分数标签
    _ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_grayStarView.right + 5.f, 0.f, 40.f, self.height)];
    _ratingLabel.textColor = KthemeColor;
    [self addSubview:_ratingLabel];
    
    // 修改父视图的宽度
    CGRect myFrame = self.frame;
    // 星星图案的宽度+标签宽度
    myFrame.size.width = CGRectGetWidth(_grayStarView.frame) + 45.f;
    self.frame = myFrame;
}

- (void)setRating:(CGFloat)rating {
    if (_rating != rating) {
        _rating = rating;
        
        // 根据评分，调整黄色星星层的宽度
        /**
         *  单元格复用，导致每一个单元格重复显示的时候，都会取计算标准的宽度。
         *  如果这个标准是变化的，每次结果都会改变。
         *  以恒定的标准来计算
         */
        //        CGRect frame = _yellowStarView.frame;  // 获取黄色星星的宽度
        CGRect frame = _grayStarView.frame;   // 获取灰色星星的宽度
        frame.size.width = (_rating / 10.0) * frame.size.width;
        _yellowStarView.frame = frame;
        
        // 设置文本
        _ratingLabel.text = [NSString stringWithFormat:@"%.1f", _rating];
    }
}

- (void)configureTextFont:(UIFont *)font {
    // 设置文本字体
    _ratingLabel.font = font;
}


@end
