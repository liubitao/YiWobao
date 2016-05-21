//
//  YWAddressEditController.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/10.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YWAddressModel;

@interface YWAddressEditController : UIViewController

@property (nonatomic,strong) YWAddressModel *addressModel;

@property (nonatomic,copy) NSString *type;

@end
