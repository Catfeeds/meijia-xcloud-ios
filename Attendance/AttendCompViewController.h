//
//  AttendCompViewController.h
//  yxz
//
//  Created by 白玉林 on 16/1/14.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface AttendCompViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)NSString *compNameString;
@property (nonatomic ,strong)NSString *compID;
@end
