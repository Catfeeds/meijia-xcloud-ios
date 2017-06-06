//
//  BuyViewController.h
//  simi
//
//  Created by 赵中杰 on 14/12/8.
//  Copyright (c) 2014年 zhirunjia.com. All rights reserved.
//

#import "FatherViewController.h"
#import "VIPLISTData.h"
@interface BuyViewController : FatherViewController
{
    NSString *_moneystring;
    VIPLISTData *_vipdata;
}

@property (nonatomic, strong)NSString *moneystring;
@property (nonatomic, strong)VIPLISTData *vipdata;
@property (nonatomic, assign)int card_type;
@property (nonatomic, strong)NSString *card_money;
@property(nonatomic ,strong)NSString *user_ID;
@property(nonatomic ,strong)NSString *order_ID;

@end
