//
//  DuiHuanTableViewCell.h
//  simi
//
//  Created by 赵中杰 on 14/12/11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DUIHUANDELEGATE <NSObject>

- (void)duihuananniuDIanji;

@end

@interface DuiHuanTableViewCell : UITableViewCell


@property (nonatomic, weak) __weak id <DUIHUANDELEGATE> delegate;

@end
