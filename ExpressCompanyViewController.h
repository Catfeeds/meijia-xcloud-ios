//
//  ExpressCompanyViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/30.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface ExpressCompanyViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *citydb;
}
@property(nonatomic ,strong)NSString *expressStr;
@property(nonatomic ,strong)NSString *express_idStr;
@end
