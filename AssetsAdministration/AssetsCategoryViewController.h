//
//  AssetsCategoryViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/31.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface AssetsCategoryViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *xcompany_setting;
}
@property(nonatomic ,strong)NSString *nameStr;
@property(nonatomic ,strong)NSString *idsStr;
@end
