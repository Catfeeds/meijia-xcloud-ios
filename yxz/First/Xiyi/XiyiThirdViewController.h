//
//  XiyiThirdViewController.h
//  simi
//
//  Created by zrj on 14-12-3.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICEXiyi.h"
@interface XiyiThirdViewController : FatherViewController
{
    SERVICEXiyi *model;
     NSArray *sourceArr;
    NSString *_price;
    NSString *title;
    NSString *tips;
    
    NSString *addr_id;
    NSString *type;
    NSString *value;
    NSString *start_date;
    NSString *start_time;
    NSString *service_hour;
}

@property (nonatomic, strong) SERVICEXiyi *model;

@property (nonatomic, strong) NSString *_price;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *tips;

@property (nonatomic, strong) NSArray *sourceArr;

@end
