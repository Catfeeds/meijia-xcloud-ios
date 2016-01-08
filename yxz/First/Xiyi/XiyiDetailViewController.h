//
//  XiyiDetailViewController.h
//  simi
//
//  Created by zrj on 14-11-11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface XiyiDetailViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *qingdanArr;

@property (nonatomic, retain) NSString *tips;

@end
