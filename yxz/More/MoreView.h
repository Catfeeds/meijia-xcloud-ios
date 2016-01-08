//
//  MoreView.h
//  simi
//
//  Created by 赵中杰 on 14/11/28.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherView.h"

@protocol MOREDELEGATE <NSObject>

- (void)selectWhichControllerToPushWithTag:(NSInteger)tag;

- (void)telephoneBtn;

@end

@interface MoreView : FatherView
{
    __weak id <MOREDELEGATE> _delegate;
}

@property (nonatomic, weak) __weak id <MOREDELEGATE> delegate;

@end
