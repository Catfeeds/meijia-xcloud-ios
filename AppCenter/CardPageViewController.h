//
//  CardPageViewController.h
//  yxz
//
//  Created by 白玉林 on 16/2/29.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface CardPageViewController : FatherViewController<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,MJRefreshBaseViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSString *latString;
@property (strong, nonatomic)NSString *lngString;
@property (nonatomic ,assign)int vcID;
@property (nonatomic ,strong)NSString *navlabelName;

@end
