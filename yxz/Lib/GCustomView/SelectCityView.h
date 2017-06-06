//
//  SelectCityView.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCityDelegate <NSObject>

- (void)SelectCtiyDelegate:(NSString *)btntitle;

@end

@interface SelectCityView : UIView

{
    __weak id<SelectCityDelegate>_delegate;
}

@property (nonatomic, weak) __weak id<SelectCityDelegate>delegate;

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array;

@end
