//
//  Create_Enterprise_Address_BookViewController.h
//  yxz
//
//  Created by 白玉林 on 16/7/5.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <sqlite3.h>
@interface Create_Enterprise_Address_BookViewController : FatherViewController<CLLocationManagerDelegate>
{
    sqlite3 *citydb;
    sqlite3 *simi;
}
@property(nonatomic,retain)CLLocationManager *locationManager;
@end
