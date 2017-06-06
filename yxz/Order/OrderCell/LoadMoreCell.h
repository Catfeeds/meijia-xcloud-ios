//
//  LoadMoreCell.h
//  simi
//
//  Created by 赵中杰 on 15/1/7.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewCell.h"

@protocol LOADMOREDELAGATE <NSObject>

- (void)loadMoreOrder;

@end

@interface LoadMoreCell : FatherViewCell
{
    NSInteger _orderCount;
}

@property (nonatomic, weak) __weak  id <LOADMOREDELAGATE>delegate;

@property (nonatomic, assign) NSInteger orderCount;

@end
