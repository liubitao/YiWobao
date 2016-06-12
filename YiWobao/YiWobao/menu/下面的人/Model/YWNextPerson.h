//
//  YWNextPerson.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/6/12.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWNextPerson : NSObject

@property (nonatomic,copy) NSString *userimg;

@property (nonatomic,copy) NSString *username;

@property (nonatomic,copy) NSString *wxname;

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *phone;

+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array;

@end
