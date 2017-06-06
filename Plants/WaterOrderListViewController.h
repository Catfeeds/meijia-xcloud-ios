//
//  WaterOrderListViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/2.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface WaterOrderListViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) NSString *waterString;
@property (nonatomic ,strong)NSString *moneyString;
@property (nonatomic ,strong)NSString *service_price_id;
@end
