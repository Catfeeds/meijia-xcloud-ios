//
//  ImagesPage.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SERVICEBannerAd.h"

@protocol imgdelegate <NSObject>

-(void)imgdelegate:(UIButton *)btn imgUrl:(NSString *)url;

@end
@interface ImagesPage : UIView<UIScrollViewDelegate>
{
    __weak id<imgdelegate>_delegate;
    
    UIScrollView *myScrollView;
    UIPageControl *myPage;

    NSArray *modelArray;
    
    NSUInteger pageIndex;
}

@property (nonatomic, weak) __weak id<imgdelegate>delegate;

- (id)initWithFrame:(CGRect)frame imgArray:(NSArray *)array;

@end

