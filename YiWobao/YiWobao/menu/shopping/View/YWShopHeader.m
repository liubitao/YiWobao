//
//  YWShopHeader.m
//  YiWobao
//
//  Created by 刘毕涛 on 16/10/21.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWShopHeader.h"
#import "YWshopButton.h"
#import "SDCycleScrollView.h"

@interface YWShopHeader ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) NSMutableArray *imageArray;


@end


@implementation YWShopHeader



- (SDCycleScrollView*)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150) shouldInfiniteLoop:YES imageNamesGroup:self.imageArray];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _cycleScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)images{
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray = images;
        [self setup];
    }
    return self;
}

- (void)setup{
 
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    
    [self addSubview:self.cycleScrollView];

    CGFloat itemWidth = kScreenWidth/4;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _cycleScrollView.bottom, kScreenWidth, 120)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"免费商品",@"蚁窝商城",@"联盟商家",@"福利认领"];
    NSArray *images = @[@"topnav-9",
                        @"topnav-10",
                        @"topnav-11",
                        @"topnav-12"];
    
    for (NSInteger i = 0; i<4; i++) {
        YWshopButton *button = [[YWshopButton alloc]initWithFrame:CGRectMake(i*itemWidth, 20, itemWidth, 80)];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    [self addSubview:view];
    self.height = view.bottom+10;
}

- (void)clickBtn:(YWshopButton *)sender{
    if (_menuBlcok) {
        _menuBlcok(sender.tag);
    }
}

- (void)setImages:(NSMutableArray *)images{
    for (int i = 0; self.subviews; i++) {
        if ([self.subviews[i] isKindOfClass:[SDCycleScrollView class]]) {
            [self.subviews[i] removeFromSuperview];
        }
    }
    [self addSubview:self.cycleScrollView];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

@end
