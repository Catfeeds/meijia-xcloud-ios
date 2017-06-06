//
//  PaymentViewController.h
//  simi
//
//  Created by 白玉林 on 15/9/15.
//  Copyright (c) 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "VIPLISTData.h"
@interface PaymentViewController : FatherViewController<UIScrollViewDelegate>
{
     NSString *_moneystring;
}
@property(nonatomic ,strong)NSString *moneystring;
@property(nonatomic ,strong)NSString *moneyStr;
@property(nonatomic ,strong)NSString *buyString;
@property (nonatomic, strong)VIPLISTData *vipdata;
@property(nonatomic ,assign)int cardTypeID;
@property(nonatomic ,strong)NSString *sec_ID;
@property(nonatomic ,strong)NSString *service_type_id;
@property(nonatomic ,strong)NSString *service_price_id;
@property(nonatomic ,strong)NSString *addssID;
@property(nonatomic ,strong)NSString *actualStr;
@end
