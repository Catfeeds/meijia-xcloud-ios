//
//  WasteRecoveryViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface WasteRecoveryViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic ,assign)int wasteID;
@end
