//
//  YWFederalShop.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWFederalShop : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *areas;
@property (nonatomic,copy) NSString *business;
@property (nonatomic,copy) NSString *frpre1;
@property (nonatomic,copy) NSString *frpre2;
@property (nonatomic,copy) NSString *frpre3;
@property (nonatomic,copy) NSString *getpre;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *logopic;
@property (nonatomic,copy) NSString *phones;
@property (nonatomic,copy) NSString *regtime;
@property (nonatomic,copy) NSString *sdesc;
@property (nonatomic,copy) NSString *sdescs;
@property (nonatomic,copy) NSString *shcate;
@property (nonatomic,copy) NSString *shnote;
@property (nonatomic,copy) NSString *skewm;
@property (nonatomic,copy) NSString *sorts;
@property (nonatomic,copy) NSString *stat;
@property (nonatomic,copy) NSString *titlename;
@property (nonatomic,copy) NSString *toppic1;
@property (nonatomic,copy) NSString *toppic2;
@property (nonatomic,copy) NSString *toppic3;
@property (nonatomic,copy) NSString *toppic4;
@property (nonatomic,copy) NSString *toppic5;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *xcode;
@property (nonatomic,copy) NSString *ybkind;
@property (nonatomic,copy) NSString *ycode;



+ (instancetype)yw_objectWithKeyValues:(NSDictionary*)dict;
+ (NSMutableArray*)yw_objectWithKeyValuesArray:(NSArray *)array;
@end
