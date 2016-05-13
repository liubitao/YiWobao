//
//  YWAddressFrame.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWAddressModel;

@interface YWAddressFrame : NSObject

//地址数据
@property (nonatomic,strong) YWAddressModel *model;

//名字frame
@property (nonatomic,assign) CGRect nameFrame;

//电话号码
@property (nonatomic,assign) CGRect phoneFrame;

//地址
@property (nonatomic,assign) CGRect addressFrame;

//默认地址
@property (nonatomic,assign) CGRect defalutFrame;

//编辑
@property (nonatomic,assign) CGRect editorFrame;

//删除
@property (nonatomic,assign) CGRect deleteFrame;


// cell的高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
