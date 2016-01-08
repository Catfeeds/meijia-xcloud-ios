//
//  CompanyViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/7.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface CompanyViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic ,strong)NSDictionary *companyDic;
@property (nonatomic ,strong)NSMutableArray *mutableArray;
@property (nonatomic ,strong)NSMutableArray *nameArray;
@property (nonatomic ,strong)NSMutableArray *mobileArray;
@property (nonatomic ,strong)NSMutableArray *idArray;
@property (nonatomic ,assign)int theNumber;
@property (nonatomic ,assign)int companyVcId;

@property (nonatomic ,strong)NSArray *dataMutableArray;
@property (nonatomic ,strong)NSArray *dataNameArray;
@property (nonatomic ,strong)NSArray *dataMobileArray;
@property (nonatomic ,strong)NSArray *dataIdArray;
@property (nonatomic ,strong)NSString *nameString;
@end
