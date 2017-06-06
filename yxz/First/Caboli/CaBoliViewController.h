//
//  CaBoliViewController.h
//  simi
//
//  Created by zrj on 14-11-17.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICECaboli.h"

@interface CaBoliViewController : FatherViewController
{
    SERVICECaboli *_bolimodel;
    
    NSString *addr_id;
    NSString *type;
    NSString *value;
    NSString *start_date;
    NSString *start_time;
    NSString *service_hour;
}

@property (nonatomic, strong)SERVICECaboli *bolimodel;
@property (nonatomic, retain) NSString *yuyinDate;
@property (nonatomic, retain) NSString *yuyinTime;
@end
