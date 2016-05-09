//
//  YWUserTool.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/6.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWUserTool.h"
#import "YWUser.h"

#define YWAccountFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.data"]

@implementation YWUserTool

+ (void)saveAccount:(YWUser *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:YWAccountFileName];
}

+ (YWUser *)account{
    YWUser *_account = [NSKeyedUnarchiver unarchiveObjectWithFile:YWAccountFileName];
    return _account;
}

+ (void)quit{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:YWAccountFileName];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:YWAccountFileName error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}
@end
