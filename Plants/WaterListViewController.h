//
//  WaterListViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/2.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface WaterListViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic ,strong)NSString *titleName;
@end
