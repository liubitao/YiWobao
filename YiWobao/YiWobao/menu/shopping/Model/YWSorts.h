//
//  YWSorts.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/20.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

/*
 Goods = "<null>";
 id = 17;
 isdel = 0;
 regtime = 1463032085;
 sorts = 17;
 title = "\U751f\U6d3b\U670d\U52a1";
 */

#import <Foundation/Foundation.h>

@interface YWSorts : NSObject

@property (nonatomic,strong) NSArray *Goods;

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *isdel;

@property (nonatomic,copy) NSString *regtime;

@property (nonatomic,copy) NSString *sorts;

@property (nonatomic,copy) NSString *title;


+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;

+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array;
@end
