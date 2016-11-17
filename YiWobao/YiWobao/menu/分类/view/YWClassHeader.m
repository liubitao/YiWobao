//
//  YWClassHeader.m
//  YiWobao
//
//  Created by 刘毕涛 on 2016/11/17.
//  Copyright © 2016年 浙江蚁窝投资管理有限公司. All rights reserved.
//

#import "YWClassHeader.h"
#import "YWshopButton.h"
#import "SDCycleScrollView.h"
#import "YWFreeView.h"
#import "YWClassModel.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface YWClassHeader ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *menus;

@end


@implementation YWClassHeader



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
        _imageArray = [NSMutableArray arrayWithArray: @[@"show1",@"show2",@"show3"]];
        _menus = images;
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

    
    for (NSInteger i = 0; i<4; i++) {
        YWClassModel *model = _menus[i];
        YWshopButton *button = [[YWshopButton alloc]initWithFrame:CGRectMake(i*itemWidth, 20, itemWidth, 80)];
        button.tag = i;
        [button setTitle:model.title forState:UIControlStateNormal];
        [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YWpic,model.pic]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    [self addSubview:view];
    
    self.height = view.bottom+10;
}

- (void)clickBtn:(YWshopButton *)sender{
    if (_menuBlcok){
        _menuBlcok(sender.tag);
    }
}


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击图片");
}

@end

