//
//  ClerkViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/12.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface ClerkViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic ,strong)UITableView *_tableView;
@property(nonatomic ,strong)NSString *service_type_id;

@property(nonatomic ,strong)NSMutableArray *seekArray;
@property(nonatomic ,strong)NSString *sec_Id;
@property(nonatomic ,strong)NSString *secID;
@property(nonatomic ,assign)int is_senior;
@property(nonatomic ,assign)int height;
@property(nonatomic ,assign)int Y;



@end
