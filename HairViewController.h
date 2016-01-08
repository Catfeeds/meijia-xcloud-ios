//
//  HairViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/9.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface HairViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)NSString *channel_id;
@end
