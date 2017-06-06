//
//  TeamWorkCityViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/9.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <sqlite3.h>
@interface TeamWorkCityViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *citydb;
}
@property(nonatomic ,strong)UITableView *cityTableView;
@property (nonatomic ,strong) NSString *ctiyString;
@property (nonatomic ,strong) NSString *addCityID;
@end
