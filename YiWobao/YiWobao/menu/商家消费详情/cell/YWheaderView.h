//
//  YWheaderView.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/23.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWShop.h"

@interface YWheaderView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
- (void)setModel:(YWShop *)shop;
@end
