//
//  RatingView.h
//  星星视图
//
//  Created by 刘毕涛 on 15/9/2.
//  Copyright (c) 2015年 文华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView

@property (nonatomic, assign) CGFloat rating;

- (void)configureTextFont:(UIFont *)font;

@end
