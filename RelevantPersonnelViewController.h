//
//  RelevantPersonnelViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/26.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface RelevantPersonnelViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic ,strong)UITableView *relevantTableview;
@property(nonatomic ,strong)NSMutableArray *mutableArray;
@property (nonatomic, strong)NSString *selectString;
@property (nonatomic, strong)NSString *numberString;
@property (nonatomic, strong)NSMutableArray *nameArray;
@property (nonatomic, strong)NSMutableArray *mobileArray;
@property (nonatomic, strong)NSMutableArray *idArray;

@property (nonatomic, strong)NSArray *dataNameArray;
@property (nonatomic, strong)NSArray *dataMobileArray;
@property (nonatomic, strong)NSArray *dataMutableArray;
@property (nonatomic, strong)NSArray *dataIdArray;
@end
