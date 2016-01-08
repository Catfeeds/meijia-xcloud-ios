//
//  jiadianDetailViewController.h
//  simi
//
//  Created by zrj on 14-11-12.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICEJiadian.h"
@interface jiadianDetailViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>



@property (nonatomic, retain) NSMutableArray *qingdanArr;

@property (nonatomic, retain) NSString *tips;

@end
