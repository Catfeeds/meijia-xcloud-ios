//
//  LeaveTypeViewController.h
//  yxz
//
//  Created by 白玉林 on 16/1/27.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface LeaveTypeViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)NSString *typeStr;
@end
