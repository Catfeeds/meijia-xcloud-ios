//
//  ask_listDetailsViewController.h
//  yxz
//
//  Created by 白玉林 on 16/6/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface ask_listDetailsViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic ,strong)NSDictionary *dataDic;
@property (nonatomic ,assign)int vcID;
@property (nonatomic ,strong)NSString *msg_id;
@end
