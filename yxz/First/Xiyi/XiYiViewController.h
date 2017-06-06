//
//  XiYiViewController.h
//  simi
//
//  Created by zrj on 14-11-4.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "SERVICEXiyi.h"
#import "SERVICEDatas.h"
@interface XiYiViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    SERVICEXiyi *model;

}
@property (nonatomic, strong) SERVICEXiyi *model;;
@property (nonatomic, strong) UITableView *myTableView;

@end
