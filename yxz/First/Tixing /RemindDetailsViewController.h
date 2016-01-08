//
//  RemindDetailsViewController.h
//  simi
//
//  Created by zrj on 14-12-6.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@protocol RemindDetailsViewControllerDelelegate <NSObject>

- (void)RemindDetailsViewControllerDelelegate;

- (void)RemindDetailsBack;

@end

@interface RemindDetailsViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mytableView;
    
    __weak id<RemindDetailsViewControllerDelelegate>_delegate;
    
}

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id<RemindDetailsViewControllerDelelegate>delegate;

@end
