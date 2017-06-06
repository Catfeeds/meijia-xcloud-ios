//
//  ChatOrderView.h
//  simi
//
//  Created by 高鸿鹏 on 15/6/19.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

@protocol chatOrderViewDelegate <NSObject>

- (void)PressBtnwithBtnTitle:(NSString *)btnTitle;

@end

@interface ChatOrderView : UIView
{
    __weak id<chatOrderViewDelegate>_delegate;
}


@property(nonatomic, weak) id<chatOrderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withModel:(ChatModel *)chatmodel;

@end
