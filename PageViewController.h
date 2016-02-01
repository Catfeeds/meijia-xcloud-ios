//
//  PageViewController.h
//  simi
//
//  Created by 白玉林 on 15/7/29.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FatherViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "JTCalendar.h"
#import "MJRefresh.h"
@interface PageViewController : UIViewController<JTCalendarDataSource,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,CLLocationManagerDelegate,MJRefreshBaseViewDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) JTCalendar *calendar;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSString *latString;
@property (strong, nonatomic)NSString *lngString;
@property (nonatomic ,assign)int vcID;
@end
