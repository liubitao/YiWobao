//
//  YWPayViewController.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/11.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPayViewController : UIViewController

@property (nonatomic,strong) NSMutableDictionary *buyArr;
@property (nonatomic,copy) NSString *total;
@property (nonatomic,assign) BOOL yb_can;
@property (nonatomic,copy) NSString *type;

@end
