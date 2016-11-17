//
//  YWClassHeader.h
//  YiWobao
//
//  Created by 刘毕涛 on 2016/11/17.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ShopHeaderMenuBlcok)(NSInteger i);

@interface YWClassHeader : UIView

@property (nonatomic,copy) ShopHeaderMenuBlcok menuBlcok;


- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)images;

- (void)setImages:(NSMutableArray *)images;

@end
