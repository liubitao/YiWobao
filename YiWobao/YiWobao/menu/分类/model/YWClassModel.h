//
//  YWClassModel.h
//  YiWobao
//
//  Created by 刘毕涛 on 2016/11/17.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWClassModel : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *sorts;
@property (nonatomic,copy) NSString *isdel;
@property (nonatomic,copy) NSString *regtime;


+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array;

@end
