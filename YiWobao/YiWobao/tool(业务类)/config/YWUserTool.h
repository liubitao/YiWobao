//
//  YWUserTool.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/6.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YWUser;

@interface YWUserTool : NSObject

+ (void)saveAccount:(YWUser *)account;

+ (YWUser *)account;

+ (void)quit;

@end
