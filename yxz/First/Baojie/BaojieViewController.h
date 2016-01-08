//
//  BaojieViewController.h
//  simi
//
//  Created by zrj on 14-10-31.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICEBaojie.h"
@interface BaojieViewController : FatherViewController
{
    UIButton *btn;
    SERVICEBaojie *baojieModel;
}

@property (nonatomic, retain) SERVICEBaojie *baojieModel;
@property (nonatomic, retain) NSString *yuyinDate;
@property (nonatomic, retain) NSString *yuyinTime;
@end
