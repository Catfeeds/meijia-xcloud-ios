//
//  VideoPaymentViewController.h
//  yxz
//
//  Created by 秦川 on 16/11/8.
//  Copyright © 2016年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "VIPLISTData.h"
@interface VideoPaymentViewController : FatherViewController<UIScrollViewDelegate>



@property(nonatomic ,strong)NSString *moneystring;
//原价价格
@property(nonatomic ,strong)NSString *moneyStr;
@property(nonatomic ,strong)NSString *buyString;
//@property (nonatomic, strong)VIPLISTData *vipdata;
//@property(nonatomic ,assign)int cardTypeID;

//partner_user_id
@property(nonatomic ,strong)NSString *sec_ID;
@property(nonatomic ,strong)NSString *service_type_id;
@property(nonatomic ,strong)NSString *service_price_id;
//可以直接传0
@property(nonatomic ,strong)NSString *addssID;
//优惠
@property(nonatomic ,strong)NSString *actualStr;
@end
