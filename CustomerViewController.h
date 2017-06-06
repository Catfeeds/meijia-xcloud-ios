//
//  CustomerViewController.h
//  yxz
//
//  Created by 白玉林 on 15/10/15.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface CustomerViewController : FatherViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSString *clientString;
@property (nonatomic ,strong)NSString *nameString;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)NSInteger cellIndex;
@end
