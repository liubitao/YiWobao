//
//  YWAderssCell.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol YWAderssCellDelegate <NSObject>

- (void)clickCell:(NSIndexPath*)indexpath tag:(NSInteger)tag;

@end

@class YWAddressFrame;


@interface YWAderssCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexpath;

@property (weak, nonatomic)  UIButton *defaultButoon;

@property (nonatomic,assign) id <YWAderssCellDelegate>delegate;


- (void)configModel:(YWAddressFrame *)addressFrame;



@end
