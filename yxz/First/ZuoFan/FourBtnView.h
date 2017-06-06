//
//  FourBtnView.h
//  simi
//
//  Created by zrj on 14-11-4.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FourbtnDelegate <NSObject>

- (void)FourBtnDelegate:(NSInteger)btnTag;

@end

@interface FourBtnView : UIView
{
    __weak id<FourbtnDelegate>_delegate;
}
@property (nonatomic,weak) __weak id<FourbtnDelegate>delegate;
- (id)initWithFrame:(CGRect)frame nameArray:(NSArray *)namearray;
@end
