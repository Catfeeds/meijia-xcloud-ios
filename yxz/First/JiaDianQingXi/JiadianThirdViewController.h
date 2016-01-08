//
//  JiadianThirdViewController.h
//  simi
//
//  Created by zrj on 14-12-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICEJiadian.h"
@interface JiadianThirdViewController : FatherViewController
{
    SERVICEJiadian *model;
    NSString *_price;
    NSString *title;
    NSString *tips;
    NSArray *sourceArr;
    
    NSString *addr_id;
    NSString *type;
    NSString *value;
    NSString *start_date;
    NSString *start_time;
    NSString *service_hour;
}

@property (nonatomic, strong) SERVICEJiadian *model;

@property (nonatomic, strong) NSString *_price;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *tips;

@property (nonatomic, strong) NSArray *sourceArr;

@end
