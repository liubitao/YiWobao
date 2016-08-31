//
//  YWdetails.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/24.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWWelfare.h"

typedef void(^PushClaim)();
@interface YWdetails : UIView
@property (strong, nonatomic) IBOutlet UIView *details_view;
@property (nonatomic,copy) PushClaim pushClaim;

- (void)setModel:(YWWelfare *)welfare;

- (void)pushClaim:(PushClaim)pushClaim;

@end
