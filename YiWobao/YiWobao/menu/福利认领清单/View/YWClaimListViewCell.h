//
//  YWClaimListViewCell.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/30.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWclaimModel.h"

typedef void(^Buy_back)(NSString*);
@interface YWClaimListViewCell : UITableViewCell

@property (nonatomic,copy) NSString* isback;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *share;
@property (weak, nonatomic) IBOutlet UILabel *memoy;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *apply;
@property (nonatomic,copy) Buy_back buy_back;

- (void)setModel:(YWclaimModel *)claimModel;

- (void)buy_back:(Buy_back)buy_back;
@end
