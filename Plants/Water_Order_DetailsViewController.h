//
//  Water_Order_DetailsViewController.h
//  yxz
//
//  Created by 白玉林 on 16/3/4.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface Water_Order_DetailsViewController : FatherViewController
@property(nonatomic ,strong)NSDictionary *dic;
@property(nonatomic ,strong)NSString *user_ID;
@property(nonatomic ,strong)NSString *order_ID;
@property(nonatomic ,assign)int details_ID;
@end
