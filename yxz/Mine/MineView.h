//
//  MineView.h
//  simi
//
//  Created by 赵中杰 on 14/11/29.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"

@protocol MainDelegate <NSObject>

- (void)selectBrnPressedWithTag:(NSInteger)btntag;

@end

@interface MineView : FatherView
{
    __weak id <MainDelegate> _delegate;
}

@property (nonatomic, weak) __weak id <MainDelegate> delegate;

@end
