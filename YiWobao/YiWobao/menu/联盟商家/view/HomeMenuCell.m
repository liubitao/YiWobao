//
//  HomeMenuCell.m
//  meituan
//
//  Created by jinzelu on 15/6/30.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "HomeMenuCell.h"
#import "YWFederal.h"


@interface HomeMenuCell ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
}

@end

@implementation HomeMenuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        int index;
        if (menuArray.count%8 == 0) {
            index = menuArray.count/8;
        }else if (menuArray.count%8 > 0 ){
            index = menuArray.count/8+1;
        }
        scrollView.contentSize = CGSizeMake(index*kScreenWidth, 150);
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;

        [self.contentView addSubview:scrollView];
        
        //创建8个
        CGFloat itemWidth = (kScreenWidth)/5;
        for (int i = 0; i < menuArray.count; i++) {
            int index;
            if (menuArray.count%8 == 0) {
                index = menuArray.count/8;
            }else if (menuArray.count%8 > 0 ){
                index = menuArray.count/8+1;
            }
            
            CGRect frame = CGRectMake( i%4*itemWidth + (index - 1)*kScreenWidth+0.5*itemWidth, ((i/4)%2 == 0)? 10:75, itemWidth, 65);
            YWFederal *federal = menuArray[i];
            NSString *title = federal.title;
            NSString *imageStr = federal.pic;
            JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
         
            btnView.tag = i;
            [scrollView addSubview:btnView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
            [btnView addGestureRecognizer:tap];
           
            }
        
        //
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenWidth/2-20, 130, 0, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = index;
        [self.contentView addSubview:_pageControl];
        [_pageControl setCurrentPageIndicatorTintColor:KthemeColor];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)OnTapBtnView:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelected:)]) {
        [self.delegate didSelected:sender.view.tag];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}


@end
