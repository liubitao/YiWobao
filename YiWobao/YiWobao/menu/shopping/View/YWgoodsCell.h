//
//  YWgoodsCell.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/20.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YWgoodsCellDelegate <NSObject>

-(void)coverDidClick:(NSIndexPath *)indexPath;


@end

@class YWGoods;

@interface YWgoodsCell : UITableViewCell

@property (nonatomic,assign) id <YWgoodsCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

- (void)setCellModel:(YWGoods *)model;


@end
