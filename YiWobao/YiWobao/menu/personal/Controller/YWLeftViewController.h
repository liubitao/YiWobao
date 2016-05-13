//
//  YWLeftViewController.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/4/29.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWLeftDelegate <NSObject>

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YWLeftViewController : UITableViewController
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) id <YWLeftDelegate> delegate;


@end