//
//  EnterpriseViewController.h
//  yxz
//
//  Created by 白玉林 on 15/12/1.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface EnterpriseViewController : FatherViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (nonatomic ,assign)int webId;
@property (nonatomic ,strong)NSArray *mutableArrat;
@property (nonatomic ,strong)NSArray *nameArray;
@property (nonatomic ,strong)NSArray *mobileArray;
@property (nonatomic ,strong)NSArray *idArray;
@property (nonatomic ,assign)int enterVcID;
@property (nonatomic ,assign)int theNumber;
@property (nonatomic ,strong)NSString *company_idStr;
@end
