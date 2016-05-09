//
//  YWWriterViewController.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/5/9.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnTextBlock)(NSString *);

@interface YWWriterViewController : UIViewController

@property (nonatomic,copy) ReturnTextBlock returnTextBlock;

-(void)returnText:(ReturnTextBlock)block;

@end
