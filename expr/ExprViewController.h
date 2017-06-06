//
//  ExprViewController.h
//  yxz
//
//  Created by 白玉林 on 16/5/11.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface ExprViewController : FatherViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong)NSString *titleName;
@end
