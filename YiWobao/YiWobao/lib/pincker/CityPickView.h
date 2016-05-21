//
//  CityPickView.h
//  CitypickerView
//
//  Created by 安浩 on 15/12/29.
//  Copyright © 2015年 www.swfitnews.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityPickView;
@protocol CityPickViewDelegate <NSObject>

- (void)selectCity:(NSString *)city;

@end


@interface CityPickView : UIView

//数据
@property (nonatomic,strong) NSDictionary *pickerDic;
@property (nonatomic,strong) NSArray *provinceArray;
@property (nonatomic,strong) NSArray *cityArray;
@property (nonatomic,strong) NSArray *townArray;
@property (nonatomic,strong) NSArray *selectedArray;


//视图
@property (strong,nonatomic) UIPickerView *pickerView;
@property (nonatomic,assign) id<CityPickViewDelegate>delegate;

@end
