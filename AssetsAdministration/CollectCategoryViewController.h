//
//  CollectCategoryViewController.h
//  yxz
//
//  Created by 白玉林 on 16/4/1.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface CollectCategoryViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate>
{
    sqlite3 *xcompany_setting;
}
@property(nonatomic ,strong)NSMutableArray *collectData;
@property(nonatomic ,strong)NSMutableArray *dataArray;
@property(nonatomic ,strong)NSArray *collectArray;
@end
