//
//  ViewController.h
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "JTCalendar.h"
#import "MJRefresh.h"


@interface ViewController : UIViewController<JTCalendarDataSource,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,CLLocationManagerDelegate,MJRefreshBaseViewDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) JTCalendar *calendar;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSString *latString;
@property (strong, nonatomic)NSString *lngString;

@end
