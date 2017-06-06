//
//  Order_ListViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface Order_ListViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic ,strong)UITableView *orderTableView;
@property(nonatomic,assign)NSInteger MsVcId;
@end
