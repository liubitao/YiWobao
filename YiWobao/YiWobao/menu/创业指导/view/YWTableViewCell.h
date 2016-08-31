//
//  YWTableViewCell.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/19.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWWelfare.h"

@interface YWTableViewCell : UITableViewCell

@property (nonatomic,assign) BOOL end;
- (void)setModel:(YWWelfare *)welfare;


@end
