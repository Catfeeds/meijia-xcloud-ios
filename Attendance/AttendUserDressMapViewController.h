//
//  AttendUserDressMapViewController.h
//  yxz
//
//  Created by 白玉林 on 16/1/14.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
typedef enum {
    NetWorkType_None = 0,
    NetWorkType_WIFI,
    NetWorkType_2G,
    NetWorkType_3G,
    NetWorkType_4G,
} NetWorkType;
@interface AttendUserDressMapViewController : FatherViewController
@property (nonatomic ,strong)NSString *company_id;
@property (nonatomic ,strong)NSString *checkin_net;
@end
