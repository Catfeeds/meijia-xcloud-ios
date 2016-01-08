//
//  roundBtnView.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoundDelegate <NSObject>

- (void)RoundDelegate:(NSInteger)btnTag;

@end

@interface roundBtnView : UIView

{
    __weak id<RoundDelegate>_delegate;

}

@property (nonatomic , weak) __weak id<RoundDelegate>delegate;

- (id)initWithFrame:(CGRect)frame nameArray:(NSArray *)namearray;

@end
