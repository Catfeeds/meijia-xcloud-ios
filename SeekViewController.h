//
//  SeekViewController.h
//  simi
//
//  Created by 白玉林 on 15/9/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface SeekViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic ,strong)UITableView *_tableView;
@property(nonatomic ,strong)NSString *service_type_id;

@end
