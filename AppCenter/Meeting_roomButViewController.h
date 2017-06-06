//
//  Meeting_roomButViewController.h
//  yxz
//
//  Created by 白玉林 on 16/2/25.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface Meeting_roomButViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic ,strong)NSString *textFieldString;
@end
