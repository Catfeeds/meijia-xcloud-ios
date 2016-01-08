//
//  CityViewController.h
//  simi
//
//  Created by 白玉林 on 15/8/31.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <sqlite3.h>
@interface CityViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *citydb;
}
@property(nonatomic ,strong)UITableView *cityTableView;
@property(nonatomic ,assign)NSInteger cityID;
@property(nonatomic ,strong)NSString *setout;
@property(nonatomic ,strong)NSString *destination;
@property(nonatomic ,assign)NSNumber *fromCityID;
@property(nonatomic ,assign)NSNumber *toCityId;
@end
