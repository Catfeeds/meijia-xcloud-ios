//
//  OrderPayViewController.h
//  yxz
//
//  Created by 白玉林 on 15/11/14.
//  Copyright © 2015年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "VIPLISTData.h"
@interface OrderPayViewController : FatherViewController
{
    NSString *_moneystring;
}
@property(nonatomic ,strong)NSString *moneystring;
@property(nonatomic ,strong)NSString *moneyStr;
@property(nonatomic ,strong)NSString *buyString;
@property(nonatomic ,strong)NSString *orderStr;
@property (nonatomic, strong)VIPLISTData *vipdata;
@property(nonatomic ,assign)int cardTypeID;
@property(nonatomic ,strong)NSString *sec_ID;
@property(nonatomic ,strong)NSString *service_type_id;
@property(nonatomic ,strong)NSString *service_price_id;

@property(nonatomic ,assign)int orderVCID;
@property(nonatomic ,strong)NSString *user_ID;
@property(nonatomic ,strong)NSString *order_ID;
@property(nonatomic ,strong)NSString *addssID;
@property(nonatomic ,strong)NSString *actualStr;
@property(nonatomic ,strong)NSDictionary *orderPayDic;
@end
