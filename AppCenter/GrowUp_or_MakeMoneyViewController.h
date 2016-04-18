//
//  GrowUp_or_MakeMoneyViewController.h
//  yxz
//
//  Created by 白玉林 on 16/2/24.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface GrowUp_or_MakeMoneyViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    sqlite3 *app_toolsdb;
}
@end
