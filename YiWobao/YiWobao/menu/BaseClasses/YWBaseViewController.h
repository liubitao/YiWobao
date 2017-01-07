//
//  YWBaseViewController.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/9/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWBaseViewController : UIViewController

- (void)initNavi;


- (void)shared;

/**push不隐藏tabbar
 */
- (void)pushController:(UIViewController *)controller;
/**push隐藏tabbar
 */
- (void)hideBottomBarPush:(UIViewController *)controller;
@end
