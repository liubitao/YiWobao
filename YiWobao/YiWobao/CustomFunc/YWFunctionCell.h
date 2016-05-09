//
//  YWFunctionCell.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/3.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWFunctionCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *itemImage;
@property (strong, nonatomic)  UILabel *itemLabel;

- (void)configureCellWithModel:(NSDictionary *)model;
@end
