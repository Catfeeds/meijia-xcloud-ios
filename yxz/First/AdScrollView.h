//
//  AdScrollView.h
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@protocol adScrollDelegate <NSObject>

- (void)goUrlIs:(NSString *)url;

@end

@interface AdScrollView : UIScrollView<UIScrollViewDelegate>
{
    __weak id <adScrollDelegate> _delegateGHP;
}
@property (nonatomic, weak) id <adScrollDelegate>delegateGHP;

@property (retain,nonatomic,readonly) UIPageControl * pageControl;
@property (retain,nonatomic,readwrite) NSArray * imageNameArray;
@property (retain,nonatomic,readonly) NSArray * adTitleArray;
@property (retain,nonatomic,readwrite) NSArray * imgGoUrlArray;
@property (assign,nonatomic,readwrite) UIPageControlShowStyle  PageControlShowStyle;
@property (assign,nonatomic,readonly) AdTitleShowStyle  adTitleStyle;

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;
@end


