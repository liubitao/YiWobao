//
//  YWClaim.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/26.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWWelfare.h"

@protocol  YWClaimDelegate<NSObject>

- (void)submit:(NSString *)number name:(NSString *)name phone:(NSString*)phone memo:(NSString *)memo;

- (void)hide;
@end

@interface YWClaim : UIView

@property (nonatomic,strong) YWWelfare *welfare;

@property (nonatomic,assign) id<YWClaimDelegate> delegate;

@end
