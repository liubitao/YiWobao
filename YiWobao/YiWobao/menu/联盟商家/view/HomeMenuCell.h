//
//  HomeMenuCell.h
//  meituan
//
//  Created by jinzelu on 15/6/30.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZMTBtnView.h"

@protocol YWhomeMenuDelegate <NSObject>

- (void)didSelected:(NSInteger)number;

@end

@interface HomeMenuCell : UITableViewCell

@property (nonatomic,assign) id  <YWhomeMenuDelegate> delegate;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;

@end
