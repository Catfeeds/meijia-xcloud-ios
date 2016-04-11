//
//  IntegralListViewController.h
//  yxz
//
//  Created by 白玉林 on 16/4/7.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface IntegralListViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic ,strong)NSString *productFractionStr;
@end
