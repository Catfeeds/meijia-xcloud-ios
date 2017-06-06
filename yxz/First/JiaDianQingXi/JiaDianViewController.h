//
//  JiaDianViewController.h
//  simi
//
//  Created by zrj on 14-11-11.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICEJiadian.h"
@interface JiaDianViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>

{
    SERVICEJiadian *model;
}
@property (nonatomic, strong) UITableView *_mytableView;

@property (nonatomic, retain) SERVICEJiadian *model;

@end
