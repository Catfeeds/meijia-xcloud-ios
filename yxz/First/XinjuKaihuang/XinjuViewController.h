//
//  XinjuViewController.h
//  simi
//
//  Created by zrj on 14-11-18.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICEXinju.h"
@interface XinjuViewController : FatherViewController
{
    SERVICEXinju *model;
    
    NSString *addr_id;
    NSString *type;
    NSString *value;
    NSString *start_date;
    NSString *start_time;
    NSString *service_hour;
}

@property (nonatomic, strong) SERVICEXinju *model;
@property (nonatomic, retain) NSString *yuyinDate;
@property (nonatomic, retain) NSString *yuyinTime;
@end
