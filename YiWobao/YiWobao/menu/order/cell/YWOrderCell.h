//
//  YWOrderCell.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWOrderModel;
@protocol YWOrderCellDelegate <NSObject>

- (void)changeState:(NSIndexPath *)indexPath tag:(NSInteger)tag type:(NSString*)type;

@end
@interface YWOrderCell : UITableViewCell


@property (nonatomic,assign) id <YWOrderCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,copy) NSString *type;

- (void)setModel:(YWOrderModel*)model;

@end
