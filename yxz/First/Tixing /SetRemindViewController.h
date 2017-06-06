//
//  SetRemindViewController.h
//  simi
//
//  Created by zrj on 14-11-26.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@protocol SetRemDelegate <NSObject>

- (void)SetRemDelegate;

@end

@interface SetRemindViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak id<SetRemDelegate>_delegate;
    
}

@property (nonatomic, weak) id<SetRemDelegate>delegate;

@property (nonatomic, strong) NSString *superior;

@property (nonatomic, assign) NSInteger arrIndex;

@property (nonatomic, strong) NSString *week;

@end
