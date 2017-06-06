//
//  ListViewController.h
//  simi
//
//  Created by 白玉林 on 15/9/4.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
@interface ListViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic ,strong)NSArray *dataArray;
@property(nonatomic ,strong)NSArray *hyArray;
@property(nonatomic ,strong)UITableView *tableView;
@end
