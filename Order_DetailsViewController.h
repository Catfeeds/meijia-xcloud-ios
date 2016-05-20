//
//  Order_DetailsViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"

@interface Order_DetailsViewController : FatherViewController<UIScrollViewDelegate>
@property(nonatomic ,strong)NSDictionary *dic;
@property(nonatomic ,strong)NSString *user_ID;
@property(nonatomic ,strong)NSString *order_ID;
@property(nonatomic ,assign)int details_ID;
@end
