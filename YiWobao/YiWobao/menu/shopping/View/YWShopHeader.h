//
//  YWShopHeader.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/10/21.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopHeaderMenuBlcok)(NSInteger i);

typedef void(^ShopHeaderHeightBlcok)(CGFloat height);

@interface YWShopHeader : UIView

@property (nonatomic,copy) ShopHeaderMenuBlcok menuBlcok;

@property (nonatomic,copy) ShopHeaderMenuBlcok middleBlcok;

@property (nonatomic,copy) ShopHeaderHeightBlcok heightBlcok;

- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)images;

- (void)setImages:(NSMutableArray *)images;
@end


typedef void(^FreeGoodsBlcok)(NSInteger i);
@interface YWFreeView : UIView

@property (nonatomic,copy) FreeGoodsBlcok FreeBlcok;

@property (nonatomic,copy) ShopHeaderHeightBlcok heightBlcok;


@end

