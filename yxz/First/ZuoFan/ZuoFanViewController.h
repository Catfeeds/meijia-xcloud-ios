//
//  ZuoFanViewController.h
//  simi
//
//  Created by zrj on 14-11-4.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICEZuofan.h"
@interface ZuoFanViewController : FatherViewController
{
    UIButton *btn;
    SERVICEZuofan *model;
    
    NSString *addr_id;
    NSString *type;
    NSString *value;
    NSString *start_date;
    NSString *start_time;
}

@property(nonatomic, retain) SERVICEZuofan *model;
@property (nonatomic, retain) NSString *yuyinDate;
@property (nonatomic, retain) NSString *yuyinTime;
@end
