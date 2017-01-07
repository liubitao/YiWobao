//
//  YWClaimListViewCell.h
//  YiWobao
//
//  Created by 刘毕涛 on 16/8/30.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWclaimModel.h"


@protocol YWClaimListDelegate <NSObject>

- (void)click:(NSIndexPath *)indexPath claim:(YWclaimModel *)claimModel;

@end

@interface YWClaimListViewCell : UITableViewCell

@property (nonatomic,strong) YWclaimModel  *claimModel;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id <YWClaimListDelegate> delegate;

- (void)setClaimModel:(YWclaimModel *)claimModel;

@end
