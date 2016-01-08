//
//  DynamicViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface DynamicViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@property(nonatomic ,strong)UITableView *tableView;
@property(nonatomic ,assign)int vcLayoutID;
@property(nonatomic ,strong)NSString *friendID;
@end
